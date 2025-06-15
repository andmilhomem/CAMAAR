# exemplo de passo para testar se cucumber está funcionando

Given("I visit the homepage") do
  visit "/hello"
end

Then("I should read {string}") do |text|
  expect(page).to have_content(text)
end
