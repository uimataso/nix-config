from setuptools import setup

with open('requirements.txt') as f:
    install_requires = f.read().splitlines()

setup(
  name='{{CODENAME}}',
  # packages=['{{CODENAME}}'],
  version='0.1.0',
  author='uima'
  description='{{NAME}}',
  install_requires=install_requires,
  # scripts=[
  #   'src/main.py',
  # ],
  entry_points={
    # example: file some_module.py -> function main
    'console_scripts': ['{{CODENAME}}=main:main']
  },
)
