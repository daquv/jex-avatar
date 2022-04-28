# jex-avatar

	• Jex log 세팅 방법 (윈도우  tomcat 8.0 기준)
	- 소스를 가져다가  특정  폴더에 소스를 집어넣는다. 
	- http://112.187.199.100:18300/markdown/JEX_CON_LOCAL_SETTING/index.html 를 보고 따라한다. 
	- Java 1.6 , tomcat 8 기준으로 한다. (tomcat 8.5 이상은 안되는거 같은……)
	- 특이점은 jex.dev.prop 파일 설정할때 가이드에는 
	- JEX.config.file=jex.avatar.local.xml, jex.avatar.dev.xml, jex.avatar.user.dev.xml 로 나와 있지만 
	- JEX.config.file=jex.avatar.dev.xml, jex.avatar.user.dev.xml, jex.avatar.local.xml 이렇게 설정해야 로그가 찍힌다
	- 
	- 특히 jex.dev.prop에 맨위에 적는 [AVATAR] 이부분은 프로젝트 이름이 됨으로 다른곳에서도 다 맞춰줘야 한다. JEX.projectId=AVATAR , server run  configuration --> arguments 에도 -DJEX.id=AVATAR 로 맞춰넣어야 함. 
	- Server arguemnt  변수 값 (그대로 복사 project id 만 맞춰준다. )
	
  -DJEX.id=AVATAR
	-DJEX.init.parameter.file=jex.dev.prop
	-DJEX.workspace.home=${workspace_loc} 
	-Dcatalina.base="C:\eclipse_workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0" -Dcatalina.home="C:\apache-tomcat-8.0.53" -Dwtp.deploy="C:\eclipse_workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps" -Djava.endorsed.dirs="C:\apache-tomcat-8.0.53\endorsed"
	 --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
	
	서버 설정 시에  web modules 설정은 다음과 같이 한다. 
	- Avatar 프로젝트 root path = "/"
	- avatar_static root paht는 home 폴더에 있는 폴더를 전부 루트로 설정 (static 경로 : avatar_static --> web --> home --> /home/css, /home/js, /home/img, /home/js)
	![image](https://user-images.githubusercontent.com/103984024/165659769-9626c339-df54-4284-ae75-1f2162e07214.png)
	- 만약 모듈이 안나오면 니 잘못. (dynamic web project로 변환해야module이 생성된다.) 
	- 로그의 루트 파일은 가이드에 보면 
	- <default level="${JEX.log.rule.default.level}" filePath="${JEX_HOME}/logs" fileName="default." dateFormat="yyyymmdd"> 로 되어 있는데 
	- <default level="${JEX.log.rule.default.level}" filePath="C:/log/jexframe/logs" fileName="default." dateFormat="yyyymmdd"> 이렇게 특정폴더를  filePath 로 잡아줘도 된다. 
	• *classpath 에 lib 추가 할적에 lib. Lib/run 에 있는 jar를 모두 추가 하고 마지막으로 tomcat 폴더의 lib 폴더에 servlet-api.jar도 추가해줘야 한다. 이거 안하면 안뜸
	• 위 vm arguments 에 ${workspace_loc} 이 부분은  workspace가 있는 폴더 경로를적어줘야 한다. Ex) c:\workspace <-- 이런식으로 
	

	
	
	
	
	
	
	

