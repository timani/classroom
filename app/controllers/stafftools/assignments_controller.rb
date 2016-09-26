# frozen_string_literal: true
module Stafftools
  class AssignmentsController < StafftoolsController
    def show
    end

    private

    def assignment
      @assignment = Assignment.find_by!(organization_id: params[:organization_id], id: params[:id])
    end
    helper_method :assignment
  end
end
