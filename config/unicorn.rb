# frozen_string_literal: true

root = '/home/deployer/apps/ModHand/current'
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen '/tmp/unicorn.ModHand.sock'
worker_processes 4
timeout 30