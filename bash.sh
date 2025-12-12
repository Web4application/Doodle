git clone https://github.com/eclipse-platform/eclipse.platform.releng.aggregator.git
cd eclipse.platform.releng.aggregator
git submodule update --init --recursive
# clean up "dirt" from previous build see Bug 420078
git submodule foreach git clean -f -d -x
git submodule foreach git reset --hard HEAD
git clean -f -d -x
git reset --hard HEAD

# update master and submodules
git checkout master
git pull --recurse-submodules
git submodule update

# run the build
mvn clean verify  -DskipTests=true

# find the results in
# eclipse.platform.releng.tychoeclipsebuilder/eclipse.platform.repository/target/products
# compile local version
mvn clean install -f eclipse.jdt.core/org.eclipse.jdt.core.compiler.batch -DlocalEcjVersion=99.99

# run build with local compiler
mvn clean verify  -DskipTests=true -Dcbi-ecj-version=99.99
