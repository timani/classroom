# frozen_string_literal: true
class GroupAssignmentRepo
  class Creator
    include GitHub::RepositoryPlan

    class Result
      class Error < StandardError; end

      class << self
        def success(group_assignment_repo)
          new(:success, assignment_repo: group_assignment_repo)
        end

        def failed(error)
          new(:failed, error: error)
        end
      end

      attr_reader :error, :group_assignment_repo

      def initialize(status, group_assignment_repo: nil, error: nil)
        @status          = status
        @assignment_repo = group_assignment_repo
        @error           = error
      end

      def success?
        @status == :success
      end

      def failed?
        @status == :failed
      end
    end

    def self.perform
    end

    def initialize
    end

    def perform
      group_assignment_repo = build_group_assignment_repo

      github_organization.private_repos_available? if group_assignment.private?

      github_repository = create_and_setup_github_repository(group_assignment_repo.repo_name)

      group_assignment_repo.github_repo_id = github_repository.id
      group_assignment_repo.save!

      Result.success(group_assignment_repo)
    rescue Result::Error => e
      Result.failed(e.message)
    end
  end
end
