require 'test_helper'

class MovementTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get movement_types_index_url
    assert_response :success
  end

  test "should get new" do
    get movement_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get movement_types_edit_url
    assert_response :success
  end

end
