# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'yaml'

# Parent class for individual awspec tests generators
class AwsSpecGenerator

  def initialize(options = {})
    @vpc_list = []
    @bucket_list = []
    @output_directory = options[:output_directory]
    if @output_directory.nil?
      raise(
        'Output dir expected by AwsSpecGenerator.new(output_directory: dir)'
      )
    end
    FileUtils.mkdir_p @output_directory
    @output_directory += File::SEPARATOR
    clear_output_dir(@output_directory)
    query_vpc_ids
    query_bucket_list
  end

  # Clear out the last run
  def clear_output_dir(dir)
    Dir.glob("#{dir}*spec.rb").each do |f|
      puts "FOUND FILES = #{f}"
      # File.delete(fn) unless !File.directory?(fn)
    end
  end

  # Generate tests for all accounts
  def generate_all(account)
    generate_ec2_tests(account)
    generate_sg_tests(account)
    generate_s3_tests(account)
    generate_nacl_tests(account)
    generate_elb_tests(account)
  end

  # Generate the EC2 tests
  def generate_ec2_tests(account)
    @vpc_list.each do |vpc|
      target_file = File.absolute_path(
        @output_directory + "ec2_on_#{vpc}_tests_spec.rb"
      )
      File.open(target_file, 'w') do |f|
        f.write("require_relative '../../spec_helper'\n\ncontext '#{vpc} tests', #{account}: true do\n\n")
      end

      begin
        stderr = Open3.capture3(
            "awspec generate ec2 #{vpc}  >> \"#{target_file}\""
        )
      rescue StandardError
        raise 'Failed to generate ec2 tests (' + stderr + ')'
      end

      File.open(target_file, 'a+') { |f|f.write("end\n") }
    end
  end

  # Generate the ELB Tests
  def generate_elb_tests(account)
    @vpc_list.each do |vpc|
      target_file = File.absolute_path(
        @output_directory + "elbs_on_#{vpc}_tests_spec.rb"
      )
      File.open(target_file, 'w') do |f|
        f.write("require_relative '../../spec_helper'\n\ncontext 'ELBs on"\
        " #{vpc} tests', #{account}: true do\n\n")
      end

      begin
        stderr = Open3.capture3(
            "awspec generate elb #{vpc}  >> \"#{target_file}\""
        )
      rescue StandardError
        raise 'Failed to generate elb tests (' + stderr + ')'
      end

      File.open(target_file, 'a+') { |f|f.write("end\n") }
    end
  end

  # Generate the SG tests
  def generate_sg_tests(account)
    @vpc_list.each do |vpc|
      target_file = File.absolute_path(
        @output_directory + "security_groups_on_#{vpc}_tests_spec.rb"
      )
      File.open(target_file, 'w') do |f|
        f.write("require_relative '../../spec_helper'\n\ncontext 'Security Groups on"\
        " #{vpc} tests', #{account}: true do\n\n")
      end

      begin
        stderr, status = Open3.capture3(
            "awspec generate security_group #{vpc}  >> \"#{target_file}\""
        )
      rescue StandardError
        raise 'Error: (' + status + ') Failed to generate security_group tests (' + stderr + ')'
      end

      File.open(target_file, 'a+') { |f|f.write("end\n") }
    end
  end

  # Generate S3 Bucket tests
  def generate_s3_tests(account)

    @bucket_list.each do |bucket|
      target_file = File.absolute_path(@output_directory +
                    "s3_buckets_on_#{bucket['Name']}_tests_spec.rb")

      File.open(target_file, 'w') do |f|
        f.write(
          "require_relative '../../spec_helper'\n\ncontext 'S3 buckets on"\
          " #{bucket['Name']} tests', #{account}: true do\n\n"
        )
      end

      begin
        stderr, status = Open3.capture3(
            "awspec generate s3 #{bucket['Name']} >> \"#{target_file}\""
        )
      rescue StandardError
        raise 'Error: (' + status + ')Failed to generate bucket tests (' + stderr + ')'
      end

      File.open(target_file, 'a+') { |f|f.write("end\n") }
    end
  end

  # Generate NACL tests
  def generate_nacl_tests(account)
    @vpc_list.each do |vpc|
      target_file = File.absolute_path(
        @output_directory + "nacls_on_#{vpc}_tests_spec.rb"
      )
      File.open(target_file, 'w') do |f|
        f.write(
          "require_relative '../../spec_helper'\n\ncontext 'NACL "\
          "on #{vpc} tests', #{account}: true do\n\n"
        )
      end

      begin
        stderr = Open3.capture3(
          "awspec generate network_acl #{vpc}  >> \"#{target_file}\""
        )
      rescue StandardError
        raise 'Failed to generate nacl tests (' + stderr + ')'
      end

      File.open(target_file, 'a+') { |f|f.write("end\n") }
    end
  end

  # retrieve the VPC names for this account
  def query_vpc_ids
    begin
      stdout, stderr, status = Open3.capture3('aws ec2 describe-vpcs')
    rescue StandardError
      raise('Error: ' + status + 'Failed to recover vpc list: (' + stderr + ')')
    end

    JSON.parse(stdout)['Vpcs'].each do |vpc|
      @vpc_list.push(vpc['VpcId'])
    end
    @vpc_list.uniq!
  end

  # Get the list of s3 bucket names
  def query_bucket_list
    begin
      stdout, stderr, status = Open3.capture3('aws s3api list-buckets')
    rescue StandardError
      raise('Error: ' + status + 'Failed to recover vpc list: (' + stderr + ')')
    end

    JSON.parse(stdout)['Buckets'].each do |bucket|
      @bucket_list.push(bucket)
    end
    @bucket_list.uniq!
  end
end
