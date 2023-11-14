Sequel.migration do
  up do
    create_table :ips do
      primary_key :id
      String :address, null: false, unique: true
      Boolean :enabled
      column :ip_version, "ENUM('ipv4', 'ipv6')", null: false
    end
  end

  down do
    drop_table :ips
  end
end
