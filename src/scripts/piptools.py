# -*- coding: utf-8 -*-
import argparse
import os
import base64
from github import GitHub
import xmlrpclib


class PipTools(object):
    def __init__(self, user_name, repo_name):
        self.user_name = user_name
        self.repo_name = repo_name
        self.github_client = GitHub(access_token=os.environ.get('HUBOT_GITHUB_API_TOKEN'))
        self.pypi_client = xmlrpclib.ServerProxy('https://pypi.python.org/pypi')

    def check(self, req_file_path):
        file_content = self._get_req_file_content(req_file_path)
        packages = self._parse_req_file_content(file_content)
        new_packages = [self._update_package(package) for package in packages]
        return new_packages

    @classmethod
    def hipchat_format(cls, package):
        if package['is_latest']:
            print "(successful)\t{} {} == {}".format(
                package['name'], package['current_version'], package['latest_version'])
        else:
            print "(failed)\t{} {} => {}".format(
                package['name'], package['current_version'], package['latest_version'])

    @classmethod
    def slack_format(cls, package):
        if package['is_latest']:
            print "(:white_check_mark:)\t{} {} == {}".format(
                package['name'], package['current_version'], package['latest_version'])
        else:
            print "(:red_circle:)\t{} {} => {}".format(
                package['name'], package['current_version'], package['latest_version'])

    def _update_package(self, package):
        latest_version = self._get_latest_version(package)
        new_package = {}
        new_package['name'] = package['name']
        new_package['current_version'] = package['current_version']
        new_package['latest_version'] = latest_version
        new_package['is_latest'] = True if latest_version == package['current_version'] else False
        return new_package

    def _get_req_file_content(self, req_file_path):
        res = self.github_client.repos(
            self.user_name,
            self.repo_name,
            'contents',
            req_file_path).get()
        return base64.b64decode(res.content)

    def _parse_req_file_content(self, contents):
        req_file_packages = []
        for line in contents.split('\n'):
            if line != '' and not line.startswith('-r') and not line.startswith('#'):
                name, version = line.split('==')
                req_file_packages.append({'name': name, 'current_version': version})
        return req_file_packages

    def _get_latest_version(self, package):
        pypi = xmlrpclib.ServerProxy('https://pypi.python.org/pypi')
        releases = pypi.package_releases(package['name'])
        return sorted(releases)[-1]


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='PiPy integration with Hubot/Chat tool')
    parser.add_argument(
        '-u', '--username',
        action='store', type=str, dest='user_name',
        required=True, help='GitHub user name')
    parser.add_argument(
        '-r', '--repository',
        action='store', type=str, dest='repo_name',
        required=True, help='GitHub repository name')
    parser.add_argument(
        '-f', '--req-file-path',
        action='store', type=str, dest='req_file_path',
        required=True, help='requirement file path on GitHub repository')

    args = parser.parse_args()
    t = PipTools(user_name=args.user_name, repo_name=args.repo_name)
    packages = t.check(args.req_file_path)
    for p in sorted(packages, key=lambda p: p['is_latest']):
        PipTools.hipchat_format(p)
