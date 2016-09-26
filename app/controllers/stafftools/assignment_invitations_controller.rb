# frozen_string_literal: true
module Stafftools
  class AssignmentInvitationsController < StafftoolsController
    def show
    end

    private

    def assignment_invitation
      @assignment_invitation ||= AssignmentInvitation.find_by!(id: params[:id])
    end
    helper_method :assignment_invitation
  end
end
