# coding=utf-8

import os
import unittest
import requests

curr_dir = os.path.abspath(os.path.dirname(__file__))

HOST = "127.0.0.1"
PORT = 10000

BASE_URL = "http://{host}:{port}".format(host=HOST, port=PORT)


class TestNgxHello(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_1_index(self):
        """测试OpenResty主页"""
        url = BASE_URL+"/"
        response = requests.get(url)
        self.assertTrue(200 == response.status_code)

    def test_2_lua(self):
        """测试hello lua页面"""
        url = BASE_URL+"/lua"
        response = requests.get(url)
        self.assertTrue(200 == response.status_code)
        self.assertTrue("Lua" in response.text)


if __name__ == '__main__':
    unittest.main(verbosity=2)
