require 'yaml'
require 'etc'

module Txgh
  class KeyManager
    class << self
      def config_from_project(project_name)
        project_config = project_config_for(project_name)
        repo_config = repo_config_for(project_config['push_translations_to'])
        Txgh::Config.new(project_config, repo_config)
      end

      def config_from_repo(repo_name)
        repo_config = repo_config_for(repo_name)
        project_config = project_config_for(repo_config['push_source_to'])
        Txgh::Config.new(project_config, repo_config)
      end

      def config_from(project_name, repo_name)
        project_config = project_config_for(project_name)
        repo_config = repo_config_for(repo_name)
        Txgh::Config.new(project_config, repo_config)
      end

      private :new

      private

      def yaml
        path = if File.file?(File.join(Etc.getpwuid.dir, "txgh.yml"))
          File.join(Etc.getpwuid.dir, "txgh.yml")
        else
          File.expand_path('../../../config/txgh.yml', __FILE__)
        end

        YAML.load(ERB.new(File.read(path)).result)
      end

      def project_config_for(project_name)
        if config = yaml['txgh']['transifex']['projects'][project_name]
          config.merge('name' => project_name)
        end
      end

      def repo_config_for(repo_name)
        if config = yaml['txgh']['github']['repos'][repo_name]
          config.merge('name' => repo_name)
        end
      end
    end
  end
end