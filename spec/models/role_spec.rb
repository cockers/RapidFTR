require 'spec_helper'

describe Role do
  it "should not be valid if name is empty" do
    role = Role.new
    role.should_not be_valid
    role.errors.on(:name).should == ["Name must not be blank"]
  end

  it "should not be valid if permissions is empty" do
    role = Role.new
    role.should_not be_valid
    role.errors.on(:permissions).should == ["Please select at least one permission"]
  end

  it "should sanitize and check for permissions" do
    role = Role.new(:name => "Name", :permissions => [""]) #Need empty array, can't use %w here.
    role.should_not be_valid
    role.errors.on(:permissions).should == ["Please select at least one permission"]
  end

  it "should not be valid if a role name has been taken already" do
    Role.create({:name => "Unique", :permissions => Permission.all_permissions})
    role = Role.new({:name => "Unique", :permissions => Permission.all_permissions})
    role.should_not be_valid
    role.errors.on(:name).should == ["A role with that name already exists, please enter a different name"]
  end

  it "should titleize role name before validating it" do
    role = Role.new(:name => "should be titleized")
    role.valid?
    role.name.should == "Should Be Titleized"
  end

  it "should create a valid role" do
    Role.new(:name => "some_role", :permissions => Permission.all_permissions).should be_valid
  end

  it "should only grant permissions that are assigned to a role" do
    role = Role.new(:name => "some_role", :permissions => [Permission::CHILDREN[:register]])
    role.valid?
    role.has_permission(Permission::CHILDREN[:register]).should == true
    role.has_permission(Permission::CHILDREN[:edit]).should == false
  end

  it "should generate id" do
    role = create :role, :name => 'test role 123'
    role.id.should == "role-test-role-123"
  end
end
