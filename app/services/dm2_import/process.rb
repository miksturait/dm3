load 'dm2_import/base.rb'
class DM2Import::Process
  def self.run
    benchmark = Benchmark.measure do
      begin
        Dm2::Support.clear

        Dm2::Project.roots.each do |root|
          customer = Dm2::Support.create_customer_from_root(root)
          if root.children.empty?
            [root]
          else
            root.children
          end.each do |child|
            Dm2::Support.rebuild_work_unit_structure_and_worklog_hours(customer, child)
          end
        end
      rescue => e
        puts e
      end
    end
    puts benchmark
  end
end

