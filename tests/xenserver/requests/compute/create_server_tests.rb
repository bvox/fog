Shindo.tests('Fog::Compute[:xenserver] | create_server request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests('create_server should') do
    raises(StandardError, 'raise exception when template nil') do
      compute.create_server 'fooserver', nil
    end

    ref = create_ephemeral_server.reference
    test('return a valid reference') do
      if (ref != "OpaqueRef:NULL") and (ref.split("1") != "NULL")
        true
      else
        false
      end
    end
    # cleanup
    destroy_ephemeral_servers
  end
  
  tests('get_vm_by_name should') do
    test('return a valid OpaqueRef') do
      (compute.get_vm_by_name(test_template_name) =~ /OpaqueRef:/) and \
        (compute.get_vm_by_name(test_template_name) != "OpaqueRef:NULL" )
    end
    returns(nil, 'return nil if VM does not exist') { compute.get_vm_by_name('sdfsdf') }
  end

  tests('create_server_raw should') do
    raises(ArgumentError, 'raise exception when name_label nil') do
      compute.create_server_raw
    end

    test('create a server') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first
        }
      )
      valid_ref? ref
    end
    # cleanup
    destroy_ephemeral_servers

    test('create a server with name foobar') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first
        }
      )
      (compute.servers.get ref).name == test_ephemeral_vm_name
    end
    # cleanup
    destroy_ephemeral_servers 'foobar'

    test('set the PV_bootloader attribute to eliloader') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          :PV_bootloader => 'eliloader',
        }
      )
      (compute.servers.get ref).pv_bootloader == 'eliloader'
    end
    # cleanup
    destroy_ephemeral_servers

    test('set the :pv_bootloader attribute to eliloader') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          :pv_bootloader => 'eliloader',
        }
      )
      (compute.servers.get ref).pv_bootloader == 'eliloader'
    end
    # cleanup
    destroy_ephemeral_servers

    test('set the "vcpus_attribute" to 1') do
      ref = compute.create_server_raw(
        {
          :name_label => test_ephemeral_vm_name,
          :affinity => compute.hosts.first,
          'vcpus_max' => '1',
        }
      )
      (compute.servers.get ref).vcpus_max == '1'
    end
    # cleanup
    destroy_ephemeral_servers

    tests('set lowercase hash attributes') do
      ref = compute.create_server_raw(
        {
          :name_label      => test_ephemeral_vm_name,
          :affinity        => compute.hosts.first,
          :vcpus_params    => {:foo => :bar},
          :hvm_boot_params => {:foo => :bar}
        }
      )
      %w{ 
        VCPUs_params
        HVM_boot_params
      }.each do |a|
        test("set the :#{a} to { :foo => 'bar' }") do
          eval "(compute.servers.get ref).#{a.to_s.downcase}['foo'] == 'bar'"
        end
      end 
      # cleanup
      destroy_ephemeral_servers

      ref = compute.create_server_raw(
        {
          :name_label         => test_ephemeral_vm_name,
          :affinity           => compute.hosts.first,
          :vcpus_at_startup   => '1',
          :vcpus_max          => '1',
          :pv_bootloader_args => '1',
          :pv_bootloader      => '1',
          :pv_kernel          => '1',
          :pv_ramdisk         => '1',
          :pv_legacy_args     => '1'
        }
      )
      %w{ VCPUs_at_startup
          VCPUs_max 
          PV_bootloader_args 
          PV_bootloader
          PV_kernel
          PV_ramdisk
          PV_legacy_args
      }.each do |a|
        test("set the :#{a} to 1") do
          eval "(compute.servers.get ref).#{a.to_s.downcase} == '1'"
        end
      end 
      # cleanup
      destroy_ephemeral_servers
    end

  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.create_server }
  end

  # Cleanup just in case
  destroy_ephemeral_servers

end
