let fs = require('fs');
let path = require('path');
let project = new Project('New Project', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/windows');
Promise.all([Project.createProject('build/windows-build', __dirname), Project.createProject('C:/HaxeToolkit/haxe/lib/Kha', __dirname), Project.createProject('C:/HaxeToolkit/haxe/lib/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	if (fs.existsSync(path.join('C:/HaxeToolkit/haxe/lib/nape', 'korefile.js'))) {
		libs.push(Project.createProject('C:/HaxeToolkit/haxe/lib/nape', __dirname));
	}
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});
