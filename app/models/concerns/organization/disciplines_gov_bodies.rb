class Organization::DisciplinesGovBodies < ApplicationRecord
    belongs_to :gov_body
    belongs_to :discipline
end
