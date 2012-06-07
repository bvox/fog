Shindo.tests('Fog::Compute[:xenserver]', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests("Compute attributes") do
    %w{ default_template default_network }.each do |attr|
      test("it should respond to #{attr}") { compute.respond_to? attr }
    end
  end

  tests("Compute collections") do
    %w{ pifs vifs hosts storage_repositories servers networks vbds vdis pools pbds }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
      test("it should respond to #{collection}.all") { eval("compute.#{collection}").respond_to? 'all' }
      test("it should respond to #{collection}.get") { eval("compute.#{collection}").respond_to? 'get' }
    end
    
    %w{ pifs vifs hosts storage_repositories servers networks vbds vdis pools pbds }.each do |collection|
      test("#{collection}.size should be >= 0") { collection.size >= 0 }
    end
    
    # Assume we always have at least a host
    tests("Hosts collection") do
      test("should be >= 1") { compute.hosts.size >= 1 }
    end
    
    # Assume we always have default network
    tests("Networks collection") do
      test("should be >= 1") { compute.networks.size >= 1 }
    end
  end

  tests "Default template" do
    test("it should NOT have a default template") { compute.default_template.nil? }
    # This template exists in our XenServer
    compute.default_template = 'squeeze-test'
    test("it should have a default template if template exists") { compute.default_template.name == 'squeeze-test' }
    test("it should be a Fog::Compute::XenServer::Server") { compute.default_template.is_a? Fog::Compute::XenServer::Server }
    test("it should return nil when not found") do
      compute.default_template = 'asdfasdfasfdwe'
      compute.default_template.nil?
    end
  end

end

