module ArchersHelper

    def archer_form_type
        if params[:action] == "new" || params[:action] == "create"
            "new"
        elsif params[:action] == "edit" || params[:action] == "update" 
            "edit" 
        end
    end

    
end
