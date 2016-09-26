# frozen_string_literal: true
module Stafftools
  class OrganizationsController < StafftoolsController
    def show
    end

    private

    def organization
      @organization ||= Organization
                        .includes(:assignments, :groupings, :group_assignments, :users)
                        .find_by!(id: params[:id])
    end
    helper_method :organization
  end
end
