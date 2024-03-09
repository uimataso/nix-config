from setuptools import setup

with open('requirements.txt') as f:
    install_requires = f.read().splitlines()

setup(
  name='foo-bar',
  # packages=['foo-bar'],
  version='0.1.0',
  #author='...',
  #description='...',
  install_requires=install_requires,
  # scripts=[
  #   'src/main.py',
  # ],
  entry_points={
    # example: file some_module.py -> function main
    'console_scripts': ['foo-bar=main:main']
  },
)
