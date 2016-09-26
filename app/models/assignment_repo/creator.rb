# frozen_string_literal: true
class AssignmentRepo
  class Creator
    include GitHub::RepositoryPlan

    attr_reader :assignment, :github_repository, :organization, :user

    class Result
      class Error < StandardError; end

      class << self
        def success(assignment_repo)
          new(:success, assignment_repo: assignment_repo)
        end

        def failed(error)
          new(:failed, error: error)
        end
      end

      attr_reader :error, :assignment_repo

      def initialize(status, assignment_repo: nil, error: nil)
        @status          = status
        @assignment_repo = assignment_repo
        @error           = error
      end

      def success?
        @status == :success
      end

      def failed?
        @status == :failed
      end
    end

    def self.perform(assignment:, organization:, user:)
      new(assignment: assignment, organization: organization, user: user).perform
    end

    def initialize(assignment:, organization:, user:)
      @assignment   = assignment
      @organization = organization
      @user         = user
    end

    def perform
      assignment_repo = build_assignment_repo

      github_organization.private_repos_available? if assignment.private?

      github_repository = create_and_setup_github_repository(assignment_repo.repo_name)

      assignment_repo.github_repo_id = github_repository.id
      assignment_repo.save!

      Result.success(assignment_repo)
    rescue Result::Error => e
      Result.failed(e.message)
    end

    private

    def add_user_as_collaborator
      github_user = GitHubUser.new(user.github_client, user.uid)
      repository  = GitHubRepository.new(organization.github_client, github_repo_id)

      GitHubRepository.delete_github_repository_on_failure(github_organization, repository) do
        repository.add_collaborator(github_user.login, repository_permissions)
      end
    end

    def build_assignment_repo
      AssignmentRepo.new(assignment: assignment, user: user, organization: organization)
    end

    def create_and_setup_github_repository(name)
      repo_description = "#{name} created by GitHub Classroom"
      @github_repository = \
        GitHubRepository.create(github_organization, name, assignment.private?, repo_description)

      if assignment.starter_code_repository.present?
        push_starter_code(github_repository.id)
      end

      add_user_as_collaborator(github_repository.id)
    end

    def github_organization
      @github_organization ||= organization.github_organization
    end

    def push_starter_code(github_repo_id)
      client = assignment.creator.github_client

      assignment_repository   = GitHubRepository.new(client, github_repo_id)
      starter_code_repository = assignment.github_repository

      GitHubRepository.delete_github_repository_on_failure(github_organization, assignment_repository) do
        assignment_repository.get_starter_code_from(starter_code_repository)
      end
    end
  end
end
