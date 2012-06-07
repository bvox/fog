def test_template_name
  'squeeze-test'
end

def test_ephemeral_vm_name
  'fog-test-server-shindo'
end

def valid_ref?(ref)
  (ref =~ /OpaqueRef:/) and \
    (ref != "OpaqueRef:NULL" )
end

def create_ephemeral_vm
  Fog::Compute[:xenserver].servers.create(:name => test_ephemeral_vm_name, 
                                          :template_name => test_template_name)
end

def create_ephemeral_server
  create_ephemeral_vm
end

def destroy_ephemeral_servers(name = test_ephemeral_vm_name)
  servers = Fog::Compute[:xenserver].servers
  # Teardown cleanup
  (servers.all :name_matches => name).each do |s|
    s.destroy
  end
  (servers.templates.find_all { |t| t.name == name}).each do |s|
    s.destroy
  end
end

def destroy_ephemeral_vms
  destroy_ephemeral_servers
end
