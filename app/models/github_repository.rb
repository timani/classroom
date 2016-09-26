# frozen_string_literal: true
class GitHubRepository < GitHubResource
  class << self
    # Public: Create a repository on GitHub the website.
    #
    # owner       - The GitHubOrganization that will own the repository.
    # name        - The String name for the Repository.
    # private     - Boolean stating whether the repository is public or private.
    # description - The String that will be the repository description.
    #
    # Example:
    #
    #   owner = Organization.find(1).github_organization
    #   GitHubRepository.create(owner, 'assignment-1', true, 'Made by GitHub Classroom')
    #   # => #<GitHubRepository:0x007f965fd5b6a8 ...>
    #
    # returns True if the repository was deleted, otherwise False.
    def create(owner, name, private, description)
      owner.create_repository(name, private: private, description: description)
    end

    # Public: Delete repository on GitHub the website when
    # a `GitHub::Error` is raised.
    #
    # Example:
    #
    #  delete_github_repository_on_failure(owner, repository) do
    #    repository.add_user_as_collaborator('tarebyte')
    #  end
    #
    # returns the block or raises a `GitHub::Error`.
    def delete_github_repository_on_failure!(owner, repository)
      yield
    rescue GitHub::Error
      delete(owner, repository.id)
      raise GitHub::Error, 'GitHub repository failed to be created'
    end

    # Public: Delete a repository on GitHub the website.
    #
    # owner   - The GitHubOrganization that owns the repository.
    # repo_id - The Integer GitHub identifier for the repository.
    #
    # Example:
    #
    #   owner = Organization.find(1).github_organization
    #   GitHubRepository.delete(owner, 8675309)
    #   # => true
    #
    # returns True if the repository was deleted, otherwise False.
    def delete(owner, repo_id)
      owner.delete_repository(repo_id)
    end

    # Public: Find a repository on GitHub the website by it's
    # name with owner.
    #
    # client - The Octokit::Client used to make the API call.
    # nwo    - The String name with owner of the repository.
    #
    # Example:
    #
    #  client = user.github_client
    #  GitHubRepository.find_by_name_with_owner!(client, 'tarebyte/dotfiles')
    #
    # returns the GitHubRepository or raises a `GitHub::Error`.
    def find_by_name_with_owner!(client, nwo)
      GitHub::Errors.with_error_handling do
        repository = client.repository(nwo)
        GitHubRepository.new(client, repository.id)
      end
    end

    # Public: Determine if the repository exists on GitHub the website.
    #
    # client  - The Octokit::Client used to make the API call.
    # nwo     - The String name with owner of the repository.
    # options - The Hash of options to pass as part of the API call.
    #
    # Example:
    #
    #  client = user.github_client
    #  GitHubRepository.present?(client, 'tarebyte/dotfiles')
    #
    # returns True if the repository exists, otherwise False.
    def present?(client, nwo, **options)
      client.repository?(nwo, options)
    end
  end

  # Public: Add an outside collaborator to a repository on GitHub
  # the website.
  #
  # collaborator - The login String of the collaborator.
  # options      - The Hash of options to pass as part of the API call.
  #
  # Example:
  #
  #  assignment_repo.github_repository.add_collaborator('tarebyte')
  #  # => true
  #
  # returns True if the repository exists, otherwise False.
  def add_collaborator(collaborator, options = {})
    GitHub::Errors.with_error_handling do
      @client.add_collaborator(@id, collaborator, options)
    end
  end

  def get_starter_code_from(source)
    GitHub::Errors.with_error_handling do
      options = {
        accept:       Octokit::Preview::PREVIEW_TYPES[:source_imports],
        vcs_username: @client.login,
        vcs_password: @client.access_token
      }

      @client.start_source_import(@id, 'git', "https://github.com/#{source.full_name}", options)
    end
  end

  # Public: Determine if the repository exists on GitHub the website.
  #
  # options - The Hash of options to pass as part of the API call.
  #
  # Example:
  #
  #  assignment_repo.github_repository.present?(client, 'tarebyte/dotfiles')
  #  # => true
  #
  # returns True if the repository exists, otherwise False.
  def present?(**options)
    self.class.present?(@client, @id, options)
  end

  private

  # Internal: List the attributes that the GitHubRepository has.
  def attributes
    %w(name full_name html_url)
  end
end
