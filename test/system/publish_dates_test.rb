require "application_system_test_case"

class PublishDatesTest < ApplicationSystemTestCase
  setup do
    @publish_date = publish_dates(:one)
  end

  test "visiting the index" do
    visit publish_dates_url
    assert_selector "h1", text: "Publish Dates"
  end

  test "creating a Publish date" do
    visit publish_dates_url
    click_on "New Publish Date"

    fill_in "Published at", with: @publish_date.published_at
    click_on "Create Publish date"

    assert_text "Publish date was successfully created"
    click_on "Back"
  end

  test "updating a Publish date" do
    visit publish_dates_url
    click_on "Edit", match: :first

    fill_in "Published at", with: @publish_date.published_at
    click_on "Update Publish date"

    assert_text "Publish date was successfully updated"
    click_on "Back"
  end

  test "destroying a Publish date" do
    visit publish_dates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Publish date was successfully destroyed"
  end
end
