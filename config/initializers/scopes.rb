# frozen_string_literal: true
module GitHubClassroom
  module Scopes
    TEACHER                  = %w(repo admin:org admin:org_hook user:email delete_repo).freeze
    GROUP_ASSIGNMENT_STUDENT = %w(admin:org user:email).freeze
    ASSIGNMENT_STUDENT       = %w(user:email).freeze
  end
end
