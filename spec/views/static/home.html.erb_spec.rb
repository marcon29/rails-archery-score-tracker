require 'rails_helper'

RSpec.describe "static/home.html.erb", type: :view do
    describe "displays correctly when no one is logged in -" do
        before(:each) do
            visit root_path
        end

        it "user navigation shows Log In and Sign Up links" do
            expect(page).to have_css("nav", id: "user-nav")
            expect(page).to have_link("Log In", href: login_path)
            expect(page).to have_link("Sign Up", href: signup_path)
            expect(page).to have_link("About", href: about_path)
        end

        it "does not show the main navigation" do
            expect(page).to_not have_css("nav", id: "main-nav")
        end

        it "main content shows the Login form" do
            
            expect(page).to have_css("form", id: "login-form")
        end
    end

    describe "displays correctly when valid user is logged in -" do
        before(:each) do
            visit root_path
        end

        it "user navigation shows Profile and Log Out links" do
            expect(page).to have_css("nav", id: "user-nav")
            expect(page).to have_link("Profile", href: user_path(current_user))
            expect(page).to have_link("Log Out", href: logout_path)
            expect(page).to have_link("About", href: about_path)
        end

        it "shows the main navigation" do
            expect(page).to have_css("nav", id: "main-nav")
        end

        it "main navigation shows the Resume Score Session link if there is an active ScoreSession" do
            expect(page).to have_css("nav", id: "main-nav")
            expect(page).to have_css("a", text: "Resume Score Session")
        end

        it "main navigation does not show the Resume Score Session link if there is NO active ScoreSession" do
            expect(page).to have_css("nav", id: "main-nav")
            expect(page).to_not have_css("a", text: "Resume Score Session")
        end

        it "main content shows correct home page content" do
            expect(page).to have_css("h1", text: "Welcome #{archer.first_name}")
            expect(page).to_not have_css("form", id: "login-form")
        end
    end
end