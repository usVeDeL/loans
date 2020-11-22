require 'test_helper'

class DocumentTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get document_types_index_url
    assert_response :success
  end

  test "should get new" do
    get document_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get document_types_edit_url
    assert_response :success
  end

end
