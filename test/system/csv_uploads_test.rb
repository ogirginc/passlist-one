require "application_system_test_case"

class CsvUploadsTest < ApplicationSystemTestCase
  test "visiting the upload page" do
    visit root_path
    assert_selector "h1", text: "Upload Users CSV"
    assert_selector "input[type='file']"
    assert_selector "input[type='submit']"
  end

  test "uploading a valid CSV file" do
    visit root_path

    attach_file "file", file_fixture("valid_users.csv")
    click_on "Upload"

    # Wait for AJAX response and check results
    assert_selector ".success h3", text: "Successfully imported 2 users"
    assert_selector ".success li", text: "John Doe"
    assert_selector ".success li", text: "Jane Smith"
    assert_no_selector ".error"
  end

  test "uploading an invalid CSV file" do
    visit root_path

    attach_file "file", file_fixture("invalid_users.csv")
    click_on "Upload"

    assert_selector ".error h3", text: "Failed to import 4 users"
    assert_text "Name can't be blank"
    assert_text "Password must be between 10 and 16 characters"
    assert_text "Password must contain at least one uppercase letter"
    assert_text "Password must contain at least one digit"
  end

  test "uploading a malformed CSV file" do
    visit root_path

    attach_file "file", file_fixture("malformed.csv")
    click_on "Upload"

    assert_selector ".error h3", text: "Failed to import 1 users"
    assert_text "An error occurred while processing the CSV"
  end

  test "uploading a non-CSV file" do
    visit root_path

    attach_file "file", file_fixture("not_a_csv.txt")
    click_on "Upload"

    assert_selector ".error h3", text: "Failed to import 1 users"
    assert_text "Please upload a CSV file"
  end

  test "trying to submit without selecting a file" do
    visit root_path
    click_on "Upload"

    assert_selector ".error h3", text: "Failed to import 1 users"
    assert_text "Please select a file to upload"
  end
end
