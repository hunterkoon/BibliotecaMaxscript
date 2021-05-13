
	/* 
	Maxscript Biblioteca Cheil - São Paulo Projeto inicial para cumprimento de metas

	script criado e idealizador por: 
	Gabriel Campos

	Equipe Cooperativa: 

	Mikael Tomaz - Nomenclatura e Blocos 
	Renato Arantes - Tabulação e Organização Prévia 
	Wilson Rossi Neto - Nomenclatura e Blocos and Tabulação
	Pedro Firmino - Idealizador e Suporte
	Matheus Terra - Suporte

	messagebox ("Biblioteca 3D Cheil - São Paulo - Brasil - Desevolvido pelo Time de Retail - 3D / Agradecimentos à Mikael Tomaz - Aux. Designer, Renato Arantes - Jr. Designer, Wilson Rossi - Sen. Designer , Pedro Firmino- Sen. Designer, Elaine Sakai - Coor. and Matheus Terra - Est." )

	*/
	libraryPath = @"D:\Materiais de Apoio\B_MaxScript\B_MaxScript\"
	
	/*------------------------------------------------------------- FUNCTIONS  -----------------------------------------------------------------------*/
	/*SET IMAGE*/
	fn setImagePath libraryPath fileName =
	(
		supportedFileExtension = # ("jpg", "png", "gif", "tif", "bmp")
		imageFound = false
		counter = 1
		for s in supportedFileExtension do
		(
			filePathName = libraryPath + "Imagens\\" + fileName+ "." + supportedFileExtension[counter]
			if doesfileexist(filePathName) do
			(
				imageFound = true
				return filePathName
				exit
			)
			counter = counter + 1
		)
		if imageFound == false do return (libraryPath + "Imagens\\Indisponivel.png")
	)
	
	libraryImagePath = setImagePath libraryPath "Biblioteca"
	
	/*GET FILES RECURSIVE*/

	fn getFilesRecursive root pattern =
	(
	dir_array = GetDirectories (root+"/*")
	for d in dir_array do
	  join dir_array (GetDirectories (d+"/*"))
	my_files = #()
	for f in dir_array do
	  join my_files (getFiles (f + pattern))
	my_files
	)

	/*GET FILES RECURSIVE ---END*/

	/*LIST FILES*/
	fn listFiles libraryPath =
	(
		modelsFound = getFilesRecursive libraryPath "*.max" as array
		counter = 1
		
		/*Remove extension and path*/
		for s in modelsFound do
		(
			modelFoundName = filenameFromPath s
			modelsFound[counter] = trimright modelFoundName ".max"
			counter = counter +1
		)
		
		return  modelsFound
	)/*LIST FILES ---END*/
	
	listGroups = #("HHP", "CE", "DA", "NPC", "BSS","PSS","CSP","SES")

	modelsFound = listFiles libraryPath 
	
	/* SEPARATE LISTS GROUPS*/
	fn separeteListGroups modelsFound givenListGroups =
	(
		listedFiles = #()
		counter =1
		
		for g in givenListGroups do
		(
			listedFiles[counter] = #()
			for val in modelsFound do
			(
				groupName = "*_" + g + "_*"
				separate = matchpattern val pattern: groupName
				isLow = matchpattern val pattern: "*_low"
				
				if separate == true do
				(
					if	isLow == false do 
					(
						append listedFiles[counter] (val)
					)
				)
			)
			counter = counter +1
		)
		return listedFiles
	) /* SEPARATE LISTS GROUPS ---END*/
	
	lists = separeteListGroups modelsFound listGroups
	
	/* SELECT GROUP NAME */
	fn selectGroupName dropdownList list givenListGroups lists imagem libraryPath = 
	(
		counter = 1
		
		for g in givenListGroups do
		(
			if dropdownList.selected == givenListGroups[counter] do imagem.filename = setImagePath libraryPath g
			if dropdownList.selection == counter  do list.items =  lists[counter]
			counter = counter+1
		)
	)/* SELECT GROUP NAME ---END */
	


	
	/*MERGE MODEL */
	fn mergeModel modelName libraryPath isLow=
	(
		if isLow == false then
		(
			mergemaxfile  (libraryPath + "Blocos\\" + modelName + ".max") #prompt
		)
		else
		(
			if doesfileexist (libraryPath + "Blocos\\" + modelName +"_low" + ".max") then
			(
				mergemaxfile  (libraryPath + "Blocos\\" + modelName +"_low" + ".max") #prompt
			)
			else(
				messagebox "Nao Disponivel"
			)
		)
		
	)


	 
	/*---------------------ROLLOUT----------------------*/

	rollout M_Biblioteca "M_Biblioteca v0.24" width:750 height:750
	(
		dropdownList 'dp1' "Categoria" pos:[24,382] width:700 height:40 enabled:true items: listGroups selection:0 align:#left
		listbox 'ls1' "Produtos" pos:[24,431] width:700 height:12 enabled:true items:#("Selecione uma Categoria ") selection:1 align:#left
		button 'import' "Mergear" pos:[625,635] width:100 height:20 align:#left 
		button 'importlow' "Mergear_low" pos:[525,635] width:100 height:20 align:#left 
		bitmap 'imagem' "Bitmap" pos:[304,43] width:420 height:315 fileName:libraryImagePath align:#left
		edittext 'info' "Informações do Produto" pos:[24,25] width:270 height:315 enabled:true readOnly:true labelOnTop:true align:#left text: " 1 - Selecione uma Categoria \n 2- Selecione um Item na Lista \n 3- Visualize o Item na imagem ao lado \n 4- Para importar escolha dar um clique duplo \n ou clicar no botão Merge ou Merge_Low "
		edittext 'busca' "Busca" pos:[24,617] width:353 height:20 enabled:true readOnly:false labelOnTop:true text:""  align:#left
		GroupBox 'grp7' "M_Biblioteca" pos:[9,362] width:727 height:325 align:#left   
		label 'lbl2' " _____________________________________ Direitos Reservados -  Cheil Brasil - 2019  - v0.25 ____________________________________\n Desenvolvido por Gabriel Campos e Pedro Firmino em parceria com Mikael Tomaz, Wilson Rossi, Rentato Arantes, Mathes Terra e Elaine Sakai" pos:[24,709] width:727 height:25 enabled:false align:#left
		
		/*SEARCH TEXT CHANGED EVENT*/
		on busca changed text do
		(
			foundSearchModels = #()
			for s in modelsFound do
				(
					searchName = "*"+M_Biblioteca.busca.text+"*"
					separate = matchpattern s pattern: searchName
					if separate == true do 
					(
						append foundSearchModels (s)
					)
				)
			M_Biblioteca.ls1.items = foundSearchModels
			if M_Biblioteca.busca.text == "" do M_Biblioteca.ls1.items = #()
		)
		
		/* SELECT DROPDOWN ITEMS EVENT*/
		on dp1 selected sel   do        
		(
			selectGroupName	M_Biblioteca.dp1 M_Biblioteca.ls1 listGroups lists imagem libraryPath
		)
		
		/*SELECT LIST ITEM EVENT*/
		on ls1 selected sel do 		
		(
			M_Biblioteca.info.text = "Informações indisponíveis"
			for i in modelsFound do (
				if M_Biblioteca.ls1.selected==i do
				(
					imagem.filename = setImagePath libraryPath i
					if doesfileexist(libraryPath + "Info\\" + i + ".txt") then
					(
						fs =openFile(libraryPath + "Info\\" + i + ".txt")
						readTxtLine = true
						fsTxt = ""
						while readTxtLine == true do
						(
							if not eof fs then
							(
								fsTxt = fsTxt + readLine fs + "\n"
							)
							else
							(
								readTxtLine == false
								exit
							)
						)
						M_Biblioteca.info.text = fsTxt
						close fs
					)
				)
			)
		)
		
		/*DOUBLE CLICK EVENT*/
		on ls1 doubleClicked itm do
		(
			mergeModel M_Biblioteca.ls1.selected libraryPath false
		)
		
		 /*CLICK MERGE BUTTON EVENT*/
		on import pressed do    
		(
			mergeModel M_Biblioteca.ls1.selected libraryPath false
		)
		
		/*MERGE LOW  BUTTON EVENT*/
		on importlow pressed do     
		(
			mergeModel M_Biblioteca.ls1.selected libraryPath true
		)
	)
	if( M_Biblioteca != undefined ) do
	(
		destroyDialog M_Biblioteca
	)
	createdialog M_Biblioteca


