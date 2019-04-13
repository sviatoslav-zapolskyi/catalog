require "application_system_test_case"

class BulkInsertListsTest < ApplicationSystemTestCase
  setup do
    @bulk_insert_list = bulk_insert_lists(:one)
  end

  test "visiting the index" do
    visit bulk_insert_lists_url
    assert_selector "h1", text: "Bulk Insert Lists"
  end

  test "creating a Bulk insert list" do
    visit bulk_insert_lists_url
    click_on "New Bulk Insert List"

    fill_in "Ean13", with: @bulk_insert_list.EAN13
    fill_in "Hash", with: @bulk_insert_list.hash_id
    click_on "Create Bulk insert list"

    assert_text "Bulk insert list was successfully created"
    click_on "Back"
  end

  test "updating a Bulk insert list" do
    visit bulk_insert_lists_url
    click_on "Edit", match: :first

    fill_in "Ean13", with: @bulk_insert_list.EAN13
    fill_in "Hash", with: @bulk_insert_list.hash_id
    click_on "Update Bulk insert list"

    assert_text "Bulk insert list was successfully updated"
    click_on "Back"
  end

  test "destroying a Bulk insert list" do
    visit bulk_insert_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bulk insert list was successfully destroyed"
  end
end
