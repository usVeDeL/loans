require 'test_helper'

class ContactTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contact_types_index_url
    assert_response :success
  end

  test "should get new" do
    get contact_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get contact_types_edit_url
    assert_response :success
  end

end
