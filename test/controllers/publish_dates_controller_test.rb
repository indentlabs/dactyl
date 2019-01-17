require 'test_helper'

class PublishDatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publish_date = publish_dates(:one)
  end

  test "should get index" do
    get publish_dates_url
    assert_response :success
  end

  test "should get new" do
    get new_publish_date_url
    assert_response :success
  end

  test "should create publish_date" do
    assert_difference('PublishDate.count') do
      post publish_dates_url, params: { publish_date: { author_id: @publish_date.author_id, book_id: @publish_date.book_id, published_at: @publish_date.published_at, publisher_id: @publish_date.publisher_id } }
    end

    assert_redirected_to publish_date_url(PublishDate.last)
  end

  test "should show publish_date" do
    get publish_date_url(@publish_date)
    assert_response :success
  end

  test "should get edit" do
    get edit_publish_date_url(@publish_date)
    assert_response :success
  end

  test "should update publish_date" do
    patch publish_date_url(@publish_date), params: { publish_date: { author_id: @publish_date.author_id, book_id: @publish_date.book_id, published_at: @publish_date.published_at, publisher_id: @publish_date.publisher_id } }
    assert_redirected_to publish_date_url(@publish_date)
  end

  test "should destroy publish_date" do
    assert_difference('PublishDate.count', -1) do
      delete publish_date_url(@publish_date)
    end

    assert_redirected_to publish_dates_url
  end
end
