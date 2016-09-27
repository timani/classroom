# frozen_string_literal: true
module Stafftools
  class AssignmentsController < StafftoolsController
    def show
    end

    def repos
      @assignment_repos = AssignmentRepo.where(assignment: assignment)
    end

    private

    def assignment
      @assignment = Assignment.includes(:organization).find_by!(id: params[:id])
    end
    helper_method :assignment
  end
end
