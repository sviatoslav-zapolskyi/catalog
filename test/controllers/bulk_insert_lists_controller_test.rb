require 'test_helper'

class BulkInsertListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulk_insert_list = bulk_insert_lists(:one)
  end

  test "should get index" do
    get bulk_insert_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_bulk_insert_list_url
    assert_response :success
  end

  test "should create bulk_insert_list" do
    assert_difference('BulkInsertList.count') do
      post bulk_insert_lists_url, params: { bulk_insert_list: { EAN13: @bulk_insert_list.EAN13, hash_id: @bulk_insert_list.hash_id } }
    end

    assert_redirected_to bulk_insert_list_url(BulkInsertList.last)
  end

  test "should show bulk_insert_list" do
    get bulk_insert_list_url(@bulk_insert_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_bulk_insert_list_url(@bulk_insert_list)
    assert_response :success
  end

  test "should update bulk_insert_list" do
    patch bulk_insert_list_url(@bulk_insert_list), params: { bulk_insert_list: { EAN13: @bulk_insert_list.EAN13, hash_id: @bulk_insert_list.hash_id } }
    assert_redirected_to bulk_insert_list_url(@bulk_insert_list)
  end

  test "should destroy bulk_insert_list" do
    assert_difference('BulkInsertList.count', -1) do
      delete bulk_insert_list_url(@bulk_insert_list)
    end

    assert_redirected_to bulk_insert_lists_url
  end
end
