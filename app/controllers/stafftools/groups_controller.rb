# frozen_string_literal: true
module Stafftools
  class GroupsController < StafftoolsController
    before_action :set_group

    def show
    end

    private

    def set_group
      @group = Group.includes(:grouping, :repo_accesses).find_by!(grouping_id: params[:grouping_id], id: params[:id])
    end
  end
end
