require "test_helper"

class CsvUploadControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get root_path
    assert_response :success
  end

  test "should handle missing file" do
    post csv_upload_path

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_includes response_json["errors"], "Please select a file to upload."
  end

  test "should handle non-CSV file" do
    file = fixture_file_upload("not_a_csv.txt", "text/plain")
    post csv_upload_path, params: { file: file }

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_includes response_json["errors"], "Please upload a CSV file."
  end

  test "should successfully import valid users" do
    file = fixture_file_upload("valid_users.csv", "text/csv")
    assert_difference "User.count", 2 do
      post csv_upload_path, params: { file: file }
    end

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_equal 2, response_json["success"].length
    assert_empty response_json["errors"]
  end

  test "should handle invalid users in CSV" do
    file = fixture_file_upload("invalid_users.csv", "text/csv")
    assert_no_difference "User.count" do
      post csv_upload_path, params: { file: file }
    end

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_empty response_json["success"]
    assert_not_empty response_json["errors"]
  end

  test "should handle malformed CSV" do
    file = fixture_file_upload("malformed.csv", "text/csv")
    assert_no_difference "User.count" do
      post csv_upload_path, params: { file: file }
    end

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_empty response_json["success"]
    assert_includes response_json["errors"].first, "An error occurred while processing the CSV"
  end
end
