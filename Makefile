# Note: This is meant for tifffile developer use only
.PHONY: all clean test release

export TEST_ARGS=--exe -v
export VERSION=`python -c "import $(NAME); print($(NAME).__version__)"`

all: clean
	python setup.py install

clean:
	rm -rf build
	rm -rf dist
	find . -name "*.pyc" -o -name "*.py,cover"| xargs rm -f

test: clean
	python setup.py build_ext -i
	export PYTHONWARNINGS="all"; nosetests $(TEST_ARGS)
	make clean

release: test
	pip install wheel
	python setup.py register
	python setup.py bdist_wheel upload
	python setup.py sdist --formats=gztar,zip upload
	git tag v$(VERSION)
	git push origin --all
	git push origin --tags
