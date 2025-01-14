require 'test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:erik)
  end

  test 'should return the home page' do
    get :index
    assert_response :success
    assert_select 'title', 'Adopt-a-Drain Savannah'
    assert_select 'p#tagline', 'Help the city avoid flooding by clearing drains of debris. Click to learn what this means.'
  end

  test 'should show search form when signed in' do
    sign_in @user
    get :index
    assert_response :success
    assert_select 'form' do
      assert_select '[action=?]', '/address'
      assert_select '[method=?]', 'get'
    end
    assert_select 'label#city_state_label', 'City'
    assert_select 'select#city_state' do
      assert_select 'option', 'Savannah, GA'
    end
    assert_select 'input#address', true
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Find drains'
    end
    assert_select 'div#map', true
  end
end
