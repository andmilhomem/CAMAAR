Given("I visit the homepage") do
  visit "/hello"
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end
