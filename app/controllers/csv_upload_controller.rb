class CsvUploadController < ApplicationController
  def new
  end

  def create
    results = { success: [], errors: [] }

    if params[:file].nil?
      results[:errors] << "Please select a file to upload."
      render json: results and return
    end

    unless params[:file].content_type == "text/csv"
      results[:errors] << "Please upload a CSV file."
      render json: results and return
    end

    begin
      ::SmarterCSV.process(params[:file].path) do |row|
        name = row[0][:name]
        password = row[0][:password]

        # Skip saving if password is blank to avoid database constraint error
        if password.blank?
          results[:errors] << "For #{name || 'unknown user'}: Password can't be blank"
          next
        end

        user = User.new(name: name, password: password)
        if user.valid?
          user.save
          results[:success] << user.name
        else
          results[:errors] << "For #{user.name || 'unknown user'}: #{user.errors.full_messages.join(', ')}"
        end
      end
    rescue StandardError => e
      results[:errors] << "An error occurred while processing the CSV: #{e.message}"
    end

    render json: results
  end
end
