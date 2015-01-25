# -*- coding: utf-8 -*-
import os
import base64
from github import GitHub
import xmlrpclib


class PypiPackage(object):
    CHAT_TOOL = os.environ.get('CHAT_TOOL')

    def __init__(self, name, current_version, latest_version):
        self.name = name
        self.current_version = current_version
        self.latest_version = latest_version

    def hipchat_format(self, package):
        if package['is_latest']:
            print "(successful)\t{} {} == {}".format(
                package['name'], package['current_version'], package['latest_version'])
        else:
            print "(failed)\t{} {} => {}".format(
                package['name'], package['current_version'], package['latest_version'])

    def slack_format(self, package):
        if package['is_latest']:
            print "(:white_check_mark:)\t{} {} == {}".format(
                package['name'], package['current_version'], package['latest_version'])
        else:
            print "(:red_circle:)\t{} {} => {}".format(
                package['name'], package['current_version'], package['latest_version'])


class PipTools(object):
    def __init__(self, user_name, repo_name):
        self.user_name = user_name
        self.repo_name = repo_name
        self.github_client = GitHub(access_token=os.environ.get('GITHUB_API_TOKEN'))
        self.pypi_client = xmlrpclib.ServerProxy('https://pypi.python.org/pypi')

    def check(self, req_file_path):
        file_content = self._get_req_file_content(req_file_path)
        packages = self._parse_req_file_content(file_content)
        new_packages = [self._update_package(package) for package in packages]
        return new_packages

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
    t = PipTools(user_name='kanmu', repo_name='clo-admin')
    packages = t.check('requirements/common.txt')
    for p in packages:
        if p['is_latest'] is True:
            print "(ok)\t{} {} == {}".format(p['name'], p['current_version'], p['latest_version'])
        else:
            print "(ng)\t{} {} => {}".format(p['name'], p['current_version'], p['latest_version'])
