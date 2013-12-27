ActiveAdmin.register Work::Unit, as: 'Work Structure' do
  config.batch_actions = false

  actions :all, except: [:destroy, :new]

  sortable tree: true,
           max_levels: 3,
           sorting_attribute: :ancestry,
           parent_method: :parent,
           children_method: :children,
           roots_method: :roots,
           protect_root: true,
           collapsible: true,
           start_collapsed: true,
           roots_collection: proc { Company.first.children }

  index :as => :sortable do
    label :name
    actions
  end
end
