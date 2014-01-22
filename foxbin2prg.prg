*---------------------------------------------------------------------------------------------------
* M�dulo.........: FOXBIN2PRG.PRG - PARA VISUAL FOXPRO 9.0
* Autor..........: Fernando D. Bozzo (mailto:fdbozzo@gmail.com)
* Fecha creaci�n.: 04/11/2013
*
* LICENCIA:
* Esta obra est� sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons.
* Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.
*
* LICENCE:
* This work is licensed under the Creative Commons Attribution 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
*
*---------------------------------------------------------------------------------------------------
* DESCRIPCI�N....: CONVIERTE EL ARCHIVO VCX/SCX/PJX INDICADO A UN "PRG H�BRIDO" PARA POSTERIOR RECONVERSI�N.
*                  * EL PRG H�BRIDO ES UN PRG CON ALGUNAS SECCIONES BINARIAS (OLE DATA, ETC)
*                  * EL OBJETIVO ES PODER USARLO COMO REEMPLAZO DEL SCCTEXT.PRG, PODER HACER MERGE
*                  DEL C�DIGO DIRECTAMENTE SOBRE ESTE NUEVO PRG Y GUARDARLO EN UNA HERRAMIENTA DE SCM
*                  COMO CVS O SIMILAR SIN NECESIDAD DE GUARDAR LOS BINARIOS ORIGINALES.
*                  * EXTENSIONES GENERADAS: VC2, SC2, PJ2   (...o VCA, SCA, PJA con archivo conf.)
*                  * CONFIGURACI�N: SI SE CREA UN ARCHIVO FOXBIN2PRG.CFG, SE PUEDEN CAMBIAR LAS EXTENSIONES
*                    PARA PODER USARLO CON SOURCESAFE PONIENDO LAS EQUIVALENCIAS AS�:
*
*                        extension: VC2=VCA
*                        extension: SC2=SCA
*                        extension: PJ2=PJA
*
*	USO/USE:
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.VCX"	&& Genera "<path>\FILE.VC2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.VC2"	&& Genera "<path>\FILE.VCX" (PRG TO BIN CONVERSION)
*
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.SCX"	&& Genera "<path>\FILE.SC2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.SC2"	&& Genera "<path>\FILE.SCX" (PRG TO BIN CONVERSION)
*
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.PJX"	&& Genera "<path>\FILE.PJ2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.PJ2"	&& Genera "<path>\FILE.PJX" (PRG TO BIN CONVERSION)
*
*---------------------------------------------------------------------------------------------------
* <HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>
* 04/11/2013	FDBOZZO		v1.0	Creaci�n inicial de las clases y soporte de los archivos VCX/SCX/PJX
* 22/11/2013	FDBOZZO		v1.1	Correcci�n de bugs
* 23/11/2013	FDBOZZO		v1.2	Correcci�n de bugs, limpieza de c�digo y refactorizaci�n
* 24/11/2013	FDBOZZO		v1.3	Correcci�n de bugs, limpieza de c�digo y refactorizaci�n
* 27/11/2013	FDBOZZO		v1.4	Agregado soporte comodines *.VCX, configuraci�n de extensiones (vca), par�metro p/log
* 27/11/2013	FDBOZZO		v1.5	Arreglo bug que no generaba form completo
* 01/12/2013	FDBOZZO		v1.6	Refactorizaci�n completa generaci�n BIN y PRG, cambio de algoritmos, arreglo de bugs, Unit Testing con FoxUnit
* 02/12/2013	FDBOZZO		v1.7	Arreglo bug "Name", barra de progreso, agregado mensaje de ayuda si se llama sin par�metros, verificaci�n y logueo de archivos READONLY con debug activa
* 03/12/2013	FDBOZZO		v1.8	Arreglo bug "Name" (otra vez), sort encapsulado y reutilizado para versiones TEXTO y BIN por seguridad
* 06/12/2013	FDBOZZO		v1.9	Arreglo bug p�rdida de propiedades causado por una mejora anterior
* 06/12/2013	FDBOZZO		v1.10	Arreglo del bug de mezcla de m�todos de una clase con la siguiente
* 07/12/2013	FDBOZZO		v1.11	Arreglo del bug de _amembers detectado por Edgar K.con la clase BlowFish.vcx (http://www.tortugaproductiva.galeon.com/docs/blowfish/index.html)
* 07/12/2013    FDBOZZO     v1.12	Agregado soporte preliminar de conversi�n de reportes y etiquetas (FRX/LBX)
* 08/12/2013	FDBOZZO		v1.13	Arreglo bug "Error 1924, TOREG is not an object"
* 15/12/2013	FDBOZZO		v1.14	Arreglo de bug AutoCenter y registro COMMENT en regeneraci�n de forms
* 08/12/2013    FDBOZZO     v1.15	Agregado soporte preliminar de conversi�n de tablas, �ndices y bases de datos (DBF,CDX,DBC)
* 18/12/2013	FDBOZZO		v1.16	Agregado soporte para men�s (MNX)
* 03/01/2014	FDBOZZO		v1.17	Agregado Unit Testing de men�s y arreglo de las incidencias del menu
* 05/01/2013	FDBOZZO		v1.18	Agregado soporte para generar estructuras TEXTO de DBFs anteriores a VFP 9, pero los binarios a VFP 9 // Arreglado bug de datos faltantes en campos de vistas // Arreglado bug mnx
* 08/01/2014	FDBOZZO		v1.19	Arreglo bug SCX-VCX: Orden incorrecto en Reserved3 ocaciona que no se disparen eventos ACCESS (y probablemente ASIGN)
* 08/01/2014	FDBOZZO		v1.19	Arreglo bug DBF: Tipo de �ndice generado incorrecto en DB2 cuando es Candidate
* 08/01/2014	FDBOZZO		v1.19	Agregado soporte para convertir PJM a PJ2
* 08/01/2014	FDBOZZO		v1.19	Agregada validaci�n al convertir Men�s con estructura anterior a VFP9
* 08/01/2014	FDBOZZO		v1.19	Cambiada la propiedad "Autor" por "Author" en los archivos MN2
* 08/01/2014	FDBOZZO		v1.19.1	Cambio en los headers de los archivos TX2 para quitar el timestamp "Generated" que causa diferencias innecesarias
* 08/01/2014	FDBOZZO		v1.19.2	Arreglo de bug PJ2: Al regenerar da un error por buscar "Autor" en vez de "Author"
* 08/01/2014	FDBOZZO		v1.19.3	Cambio en los timestamps de los TXT para mantener los valores vac�os que generaban much�simas diferencias
* 22/01/2014	FDBOZZO		v1.19.4	Nuevo par�metro Recompile para forzar la recompilaci�n. Ahora por defecto el binario no se recompila para ganar velocidad y evitar errores. Debe recompilar manualmente.
* 22/01/2014	FDBOZZO		v1.19.4	DBC: Agregado soporte para comentarios multil�nea (propiedad Comment)
* </HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>
*
*---------------------------------------------------------------------------------------------------
* <TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>
* 23/11/2013	Luis Mart�nez	REPORTE BUG scx v1.4: En algunos forms solo se generaba el dataenvironment (arreglado en v.1.5)
* 27/11/2013	Fidel Charny	REPORTE BUG vcx v1.5: Error en el guardado de ciertas propiedades de array (arreglado en v.1.6)
* 02/12/2013	Fidel Charny	REPORTE BUG scx v1.6: Se pierden algunas propiedades y no muestra picture si "Name" no es la �ltima (arreglado en v.1.7)
* 03/12/2013	Fidel Charny	REPORTE BUG scx v1.7: Se siguen perdiendo algunas propiedades por implementaci�n defectuosa del arreglo anterior (arreglado en v.1.8)
* 03/12/2013	Fidel Charny	REPORTE BUG scx v1.8: Se siguen perdiendo algunas propiedades por implementaci�n defectuosa de una mejora anterior (arreglado en v.1.9)
* 06/12/2013	Fidel Charny	REPORTE BUG scx v1.9: Cuando hay m�todos que tienen el mismo nombre, aparecen mezclados en objetos a los que no corresponden (arreglado en v.1.10)
* 07/12/2013	Edgar Kummers	REPORTE BUG vcx v1.10: Cuando se parsea una clase con un _memberdata largo, se parsea mal y se corrompe el valor (arreglado en v.1.11)
* 08/12/2013	Fidel Charny	REPORTE BUG frx v1.12: Cuando se convierten algunos reportes da "Error 1924, TOREG is not an object" (arreglado en v.1.13)
* 14/12/2013	Arturo Ramos	REPORTE BUG scx v1.13: La regeneraci�n de los forms (SCX) no respeta la propiedad AutoCenter, estando pero no funcionando. (arreglado en v.1.14)
* 14/12/2013	Fidel Charny	REPORTE BUG scx v1.13: La regeneraci�n de los forms (SCX) no regenera el �ltimo registro COMMENT (arreglado en v.1.14)
* 01/01/2014	Fidel Charny	REPORTE BUG mnx v1.16: El men� no siempre respeta la posici�n original LOCATION y a veces se genera mal el MNX (se arregla en v1.17)
* 05/01/2014	Fidel Charny	REPORTE BUG mnx v1.17: Se genera cl�usula "DO" o llamada Command cuando no Procedure ni Command que llamar // Diferencia de Case en NAME (se arregla en v1.18)
* 07/01/2014	F.D.Bozzo		BUG vcx/scx v1.18: Los *m�todos deben ir siempre al final en el Reserved3, si no los eventos ACCESS no se disparan
* </TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>
*
*---------------------------------------------------------------------------------------------------
* TRAMIENTOS ESPECIALES DE ASIGNACIONES DE PROPIEDADES:
*	PROPIEDAD				ARREGLO Y EJEMPLO
*-------------------------	--------------------------------------------------------------------------------------
*	_memberdata				Se separan las definiciones en lineas para evitar una sola muy larga
*
*---------------------------------------------------------------------------------------------------
* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
* tc_InputFile				(v! IN    ) Nombre completo (fullpath) del archivo a convertir
* tcType_na					(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcTextName_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tlGenText_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcDontShowErrors			(v? IN    ) '1' para NO mostrar errores con MESSAGEBOX
* tcDebug					(v? IN    ) '1' para depurar en el sitio donde ocurre el error (solo modo desarrollo)
* tcDontShowProgress		(v? IN    ) '1' para NO mostrar la ventana de progreso
* tcOriginalFileName		(v? IN    ) Sirve para los casos en los que inputFile es un nombre temporal y se quiere generar
*							            el nombre correcto dentro de la versi�n texto (por ej: en los PJ2 y las cabeceras)
* tcRecompile				(v? IN    ) Indica recompilar ('1') el binario una vez regenerado. [Cambio de funcionamiento por defecto]
*										Este cambio es para ganar tiempo, velocidad y seguridad. Adem�s la recompilaci�n que hace FoxBin2Prg
*										se hace desde el directorio del archivo, con lo que las referencias relativas pueden
*										generar errores de compilaci�n, t�picamente los #include.
*										NOTA: Si en vez de '1' se indica un Path (p.ej, el del proyecto, se usar� como base para recompilar
*
*							Ej: DO FOXBIN2PRG.PRG WITH "C:\DESA\INTEGRACION\LIBRERIA.VCX"
*---------------------------------------------------------------------------------------------------
LPARAMETERS tc_InputFile, tcType_na, tcTextName_na, tlGenText_na, tcDontShowErrors, tcDebug, tcDontShowProgress, tcOriginalFileName, tcRecompile

*-- Internacionalizaci�n / Internationalization
*-- Fin / End

*-- NO modificar! / Do NOT change!
#DEFINE C_CMT_I				'*--'
#DEFINE C_CMT_F				'--*'
#DEFINE C_METADATA_I		'*< CLASSDATA:'
#DEFINE C_METADATA_F		'/>'
#DEFINE C_LEN_METADATA_I	LEN(C_METADATA_I)
#DEFINE C_OLE_I				'*< OLE:'
#DEFINE C_OLE_F				'/>'
#DEFINE C_LEN_OLE_I			LEN(C_OLE_I)
#DEFINE C_DEFINED_PAM_I		'*<DefinedPropArrayMethod>'
#DEFINE C_DEFINED_PAM_F		'*</DefinedPropArrayMethod>'
#DEFINE C_LEN_DEFINED_PAM_I	LEN(C_DEFINED_PAM_I)
#DEFINE C_LEN_DEFINED_PAM_F	LEN(C_DEFINED_PAM_F)
#DEFINE C_END_OBJECT_I		'*< END OBJECT:'
#DEFINE C_END_OBJECT_F		'/>'
#DEFINE C_LEN_END_OBJECT_I	LEN(C_END_OBJECT_I)
#DEFINE C_FB2PRG_META_I		'*< FOXBIN2PRG:'
#DEFINE C_FB2PRG_META_F		'/>'
#DEFINE C_DEFINE_CLASS		'DEFINE CLASS'
#DEFINE C_ENDDEFINE			'ENDDEFINE'
#DEFINE C_TEXT				'TEXT'
#DEFINE C_ENDTEXT			'ENDTEXT'
#DEFINE C_PROCEDURE			'PROCEDURE'
#DEFINE C_ENDPROC			'ENDPROC'
#DEFINE C_WITH				'WITH'
#DEFINE C_ENDWITH			'ENDWITH'
#DEFINE C_SRV_HEAD_I		'*<ServerHead>'
#DEFINE C_SRV_HEAD_F		'*</ServerHead>'
#DEFINE C_SRV_DATA_I		'*<ServerData>'
#DEFINE C_SRV_DATA_F		'*</ServerData>'
#DEFINE C_DEVINFO_I			'*<DevInfo>'
#DEFINE C_DEVINFO_F			'*</DevInfo>'
#DEFINE C_BUILDPROJ_I		'*<BuildProj>'
#DEFINE C_BUILDPROJ_F		'*</BuildProj>'
#DEFINE C_PROJPROPS_I		'*<ProjectProperties>'
#DEFINE C_PROJPROPS_F		'*</ProjectProperties>'
#DEFINE C_FILE_META_I		'*< FileMetadata:'
#DEFINE C_FILE_META_F		'/>'
#DEFINE C_FILE_CMTS_I		'*<FileComments>'
#DEFINE C_FILE_CMTS_F		'*</FileComments>'
#DEFINE C_FILE_EXCL_I		'*<ExcludedFiles>'
#DEFINE C_FILE_EXCL_F		'*</ExcludedFiles>'
#DEFINE C_FILE_TXT_I		'*<TextFiles>'
#DEFINE C_FILE_TXT_F		'*</TextFiles>'
#DEFINE C_FB2P_VALUE_I		'<fb2p_value>'
#DEFINE C_FB2P_VALUE_F		'</fb2p_value>'
#DEFINE C_LEN_FB2P_VALUE_I	LEN(C_FB2P_VALUE_I)
#DEFINE C_LEN_FB2P_VALUE_F	LEN(C_FB2P_VALUE_F)
#DEFINE C_VFPDATA_I			'<VFPData>'
#DEFINE C_VFPDATA_F			'</VFPData>'
#DEFINE C_MEMBERDATA_I		C_VFPDATA_I
#DEFINE C_MEMBERDATA_F		C_VFPDATA_F
#DEFINE C_LEN_MEMBERDATA_I	LEN(C_MEMBERDATA_I)
#DEFINE C_LEN_MEMBERDATA_F	LEN(C_MEMBERDATA_F)
#DEFINE C_DATA_I			'<![CDATA['
#DEFINE C_DATA_F			']]>'
#DEFINE C_TAG_REPORTE		'Reportes'
#DEFINE C_TAG_REPORTE_I		'<' + C_TAG_REPORTE + '>'
#DEFINE C_TAG_REPORTE_F		'</' + C_TAG_REPORTE + '>'
#DEFINE C_DBF_HEAD_I		'<DBF'
#DEFINE C_DBF_HEAD_F		'/>'
#DEFINE C_LEN_DBF_HEAD_I	LEN(C_DBF_HEAD_I)
#DEFINE C_LEN_DBF_HEAD_F	LEN(C_DBF_HEAD_F)
#DEFINE C_CDX_I				'<indexFile>'
#DEFINE C_CDX_F				'</indexFile>'
#DEFINE C_LEN_CDX_I			LEN(C_CDX_I)
#DEFINE C_LEN_CDX_F			LEN(C_CDX_F)
#DEFINE C_LEN_INDEX_I		LEN(C_INDEX_I)
#DEFINE C_LEN_INDEX_F		LEN(C_INDEX_F)
#DEFINE C_DATABASE_I		'<DATABASE>'
#DEFINE C_DATABASE_F		'</DATABASE>'
#DEFINE C_STORED_PROC_I		'<STOREDPROCEDURES><![CDATA['
#DEFINE C_STORED_PROC_F		']]></STOREDPROCEDURES>'
#DEFINE C_TABLE_I			'<TABLE>'
#DEFINE C_TABLE_F			'</TABLE>'
#DEFINE C_TABLES_I			'<TABLES>'
#DEFINE C_TABLES_F			'</TABLES>'
#DEFINE C_VIEW_I			'<VIEW>'
#DEFINE C_VIEW_F			'</VIEW>'
#DEFINE C_VIEWS_I			'<VIEWS>'
#DEFINE C_VIEWS_F			'</VIEWS>'
#DEFINE C_FIELD_I			'<FIELD>'
#DEFINE C_FIELD_F			'</FIELD>'
#DEFINE C_FIELDS_I			'<FIELDS>'
#DEFINE C_FIELDS_F			'</FIELDS>'
#DEFINE C_CONNECTION_I		'<CONNECTION>'
#DEFINE C_CONNECTION_F		'</CONNECTION>'
#DEFINE C_CONNECTIONS_I		'<CONNECTIONS>'
#DEFINE C_CONNECTIONS_F		'</CONNECTIONS>'
#DEFINE C_RELATION_I		'<RELATION>'
#DEFINE C_RELATION_F		'</RELATION>'
#DEFINE C_RELATIONS_I		'<RELATIONS>'
#DEFINE C_RELATIONS_F		'</RELATIONS>'
#DEFINE C_INDEX_I			'<INDEX>'
#DEFINE C_INDEX_F			'</INDEX>'
#DEFINE C_INDEXES_I			'<INDEXES>'
#DEFINE C_INDEXES_F			'</INDEXES>'
#DEFINE C_PROC_CODE_I		'*<Procedures>'
#DEFINE C_PROC_CODE_F		'*</Procedures>'
#DEFINE C_SETUPCODE_I		'*<SetupCode>'
#DEFINE C_SETUPCODE_F		'*</SetupCode>'
#DEFINE C_CLEANUPCODE_I		'*<CleanupCode>'
#DEFINE C_CLEANUPCODE_F		'*</CleanupCode>'
#DEFINE C_MENUCODE_I		'*<MenuCode>'
#DEFINE C_MENUCODE_F		'*</MenuCode>'
#DEFINE C_MENUTYPE_I		'*<MenuType>'
#DEFINE C_MENUTYPE_F		'</MenuType>'
#DEFINE C_MENULOCATION_I	'*<MenuLocation>'
#DEFINE C_MENULOCATION_F	'</MenuLocation>'
*--
#DEFINE C_TAB				CHR(9)
#DEFINE C_CR				CHR(13)
#DEFINE C_LF				CHR(10)
#DEFINE CR_LF				C_CR + C_LF
#DEFINE C_MPROPHEADER		REPLICATE( CHR(1), 517 )
*-- Fin / End

*-- From FOXPRO.H
*-- File Object Type Property
#DEFINE FILETYPE_DATABASE          "d"  && Database (.DBC)
#DEFINE FILETYPE_FREETABLE         "D"  && Free table (.DBF)
#DEFINE FILETYPE_QUERY             "Q"  && Query (.QPR)
#DEFINE FILETYPE_FORM              "K"  && Form (.SCX)
#DEFINE FILETYPE_REPORT            "R"  && Report (.FRX)
#DEFINE FILETYPE_LABEL             "B"  && Label (.LBX)
#DEFINE FILETYPE_CLASSLIB          "V"  && Class Library (.VCX)
#DEFINE FILETYPE_PROGRAM           "P"  && Program (.PRG)
#DEFINE FILETYPE_APILIB            "L"  && API Library (.FLL)
#DEFINE FILETYPE_APPLICATION       "Z"  && Application (.APP)
#DEFINE FILETYPE_MENU              "M"  && Menu (.MNX)
#DEFINE FILETYPE_TEXT              "T"  && Text (.TXT, .H., etc.)
#DEFINE FILETYPE_OTHER             "x"  && Other file types not enumerated above

*-- Server Object Instancing Property
#DEFINE SERVERINSTANCE_SINGLEUSE     1  && Single use server
#DEFINE SERVERINSTANCE_NOTCREATABLE  2  && Instances creatable only inside Visual FoxPro
#DEFINE SERVERINSTANCE_MULTIUSE      3  && Multi-use server
*-- Fin / End

*******************************************************************************************************************
*-- INTERNACIONALIZACI�N / INTERNATIONALIZATION
*******************************************************************************************************************
#IF .T. &&VERSION(3) == "34"	&& Espa�ol (Spanish) [NO FUNCIONA M�S ESTO :( ]
	#DEFINE C_FOXBIN2PRG_JUST_VFP_9_LOC					'�FOXBIN2PRG es solo para Visual FoxPro 9.0!'
	#DEFINE C_FOXBIN2PRG_WARN_CAPTION_LOC				'FOXBIN2PRG: �ATENCI�N!'
	#DEFINE FOXBIN2PRG_INFO_SINTAX_LOC					'FOXBIN2PRG <cEspecArchivo.Ext>  [cType_ND  cTextName_ND  cGenText_ND  cNoMostrarErrores  cDebug]' + CR_LF + CR_LF ;
		+ 'Ejemplo para generar los TXT de todos los VCX de "c:\desa\clases", sin mostrar ventana de error y generando archivo LOG: ' + CR_LF ;
		+ '   FOXBIN2PRG "c:\desa\clases\*.vcx"  "0"  "0"  "0"  "1"  "1"' + CR_LF + CR_LF ;
		+ 'Ejemplo para generar los VCX de todos los TXT de "c:\desa\clases", sin mostrar ventana de error y sin LOG: ' + CR_LF ;
		+ '   FOXBIN2PRG "c:\desa\clases\*.vc2"  "0"  "0"  "0"  "1"  "0"'
	#DEFINE ASTERISK_EXT_NOT_ALLOWED_LOC				'No se admiten extensiones * o ? porque es peligroso (se pueden pisar binarios con archivo xx2 vac�os).'
	#DEFINE C_PROCESSING_LOC							'Procesando archivo '
	#DEFINE C_FILE_DOESNT_EXIST_LOC						"El archivo no existe:"
	#DEFINE C_SOURCEFILE_LOC							"Archivo origen: "
	#DEFINE C_PROCESS_PROGRESS_LOC						"Avance del proceso: "
	#DEFINE C_CONVERTER_UNLOAD_LOC						"Descarga del conversor"
	#DEFINE C_CONVERTING_FILE_LOC						"Convirtiendo archivo "
	#DEFINE C_BACKUP_OF_LOC								"Backup de: "
	#DEFINE C_ONLY_SETNAME_AND_GETNAME_RECOGNIZED_LOC	'Operaci�n no reconocida. Solo re reconoce SETNAME y GETNAME.'
	#DEFINE C_BACKLINK_CANT_UPDATE_BL_LOC				'No se pudo actualizar el backlink'
	#DEFINE C_BACKLINK_OF_TABLE_LOC						'de la tabla'

#ELSE	&& English
	#DEFINE C_FOXBIN2PRG_JUST_VFP_9_LOC					'FOXBIN2PRG is only for Visual FoxPro 9.0!'
	#DEFINE C_FOXBIN2PRG_WARN_CAPTION_LOC				'FOXBIN2PRG: WARNING!'
	#DEFINE FOXBIN2PRG_INFO_SINTAX_LOC					'FOXBIN2PRG <cFileSpec.Ext>  [cType_NA  cTextName_NA  cGenText_NA  cDontShowErrors  cDebug  cDontShowProgress  cOriginalFileName  cRecompile]' + CR_LF + CR_LF ;
		+ 'Example to generate TXT of all VCX of "c:\desa\clases", without showing error window and generating LOG file: ' + CR_LF ;
		+ '   FOXBIN2PRG "c:\desa\clases\*.vcx"  "0"  "0"  "0"  "1"  "1"' + CR_LF + CR_LF ;
		+ 'Example to generate TXT of all VCX of "c:\desa\clases", without showing error window and without LOG file: ' + CR_LF ;
		+ '   FOXBIN2PRG "c:\desa\clases\*.vc2"  "0"  "0"  "0"  "1"  "0"'
	#DEFINE ASTERISK_EXT_NOT_ALLOWED_LOC				'* and ? extensions are not allowed because is dangerous (binaries can be overwriten with xx2 empty files)'
	#DEFINE C_PROCESSING_LOC							'Processing file '
	#DEFINE C_FILE_DOESNT_EXIST_LOC						"File doesn't exist:"
	#DEFINE C_SOURCEFILE_LOC							"Source file: "
	#DEFINE C_PROCESS_PROGRESS_LOC						"Process Progress: "
	#DEFINE C_CONVERTER_UNLOAD_LOC						"Converter unload"
	#DEFINE C_CONVERTING_FILE_LOC						"Converting file "
	#DEFINE C_BACKUP_OF_LOC								"Backup of: "
	#DEFINE C_ONLY_SETNAME_AND_GETNAME_RECOGNIZED_LOC	'Operation not recognized. Only SETNAME and GETNAME allowed.'
	#DEFINE C_BACKLINK_CANT_UPDATE_BL_LOC				'Could not update backlink'
	#DEFINE C_BACKLINK_OF_TABLE_LOC						'of table'

#ENDIF
*******************************************************************************************************************

PUBLIC goCnv AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
LOCAL lnResp
goCnv	= CREATEOBJECT("c_foxbin2prg")
lnResp	= goCnv.ejecutar( tc_InputFile, tcType_na, tcTextName_na, tlGenText_na, tcDontShowErrors, tcDebug ;
	, '', NULL, NULL, .F., tcOriginalFileName, tcRecompile )

ADDPROPERTY(_SCREEN, 'ExitCode', lnResp)
IF _VFP.STARTMODE <= 1
	RETURN lnResp
ENDIF

*-- Muy �til para procesos batch que capturan el c�digo de error
DECLARE ExitProcess IN Win32API INTEGER ExitCode
IF NOT EMPTY(lnResp)
	ExitProcess(1)
ENDIF

QUIT


*******************************************************************************************************************
DEFINE CLASS c_foxbin2prg AS CUSTOM
	#IF .F.
		LOCAL THIS AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="convertir" display="Convertir"/>] ;
		+ [<memberdata name="c_curdir" display="c_CurDir"/>] ;
		+ [<memberdata name="c_foxbin2prg_fullpath" display="c_Foxbin2prg_FullPath"/>] ;
		+ [<memberdata name="c_inputfile" display="c_InputFile"/>] ;
		+ [<memberdata name="c_originalfilename" display="c_OriginalFileName"/>] ;
		+ [<memberdata name="c_outputfile" display="c_OutputFile"/>] ;
		+ [<memberdata name="c_type" display="c_Type"/>] ;
		+ [<memberdata name="c_logfile" display="c_LogFile"/>] ;
		+ [<memberdata name="c_textlog" display="c_TextLog"/>] ;
		+ [<memberdata name="c_db2" display="c_DB2"/>] ;
		+ [<memberdata name="c_dc2" display="c_DC2"/>] ;
		+ [<memberdata name="c_fr2" display="c_FR2"/>] ;
		+ [<memberdata name="c_lb2" display="c_LB2"/>] ;
		+ [<memberdata name="c_mn2" display="c_MN2"/>] ;
		+ [<memberdata name="c_pj2" display="c_PJ2"/>] ;
		+ [<memberdata name="c_sc2" display="c_SC2"/>] ;
		+ [<memberdata name="c_vc2" display="c_VC2"/>] ;
		+ [<memberdata name="dobackup" display="doBackup"/>] ;
		+ [<memberdata name="ejecutar" display="Ejecutar"/>] ;
		+ [<memberdata name="exception2str" display="Exception2Str"/>] ;
		+ [<memberdata name="get_program_header" display="get_PROGRAM_HEADER"/>] ;
		+ [<memberdata name="getnext_bak" display="getNext_BAK"/>] ;
		+ [<memberdata name="lfilemode" display="lFileMode"/>] ;
		+ [<memberdata name="l_debug" display="l_Debug"/>] ;
		+ [<memberdata name="l_methodsort_enabled" display="l_MethodSort_Enabled"/>] ;
		+ [<memberdata name="l_propsort_enabled" display="l_PropSort_Enabled"/>] ;
		+ [<memberdata name="l_recompile" display="l_Recompile"/>] ;
		+ [<memberdata name="l_reportsort_enabled" display="l_ReportSort_Enabled"/>] ;
		+ [<memberdata name="l_test" display="l_Test"/>] ;
		+ [<memberdata name="l_showerrors" display="l_ShowErrors"/>] ;
		+ [<memberdata name="l_showprogress" display="l_ShowProgress"/>] ;
		+ [<memberdata name="normalizarcapitalizacionarchivos" display="normalizarCapitalizacionArchivos"/>] ;
		+ [<memberdata name="n_fb2prg_version" display="n_FB2PRG_Version"/>] ;
		+ [<memberdata name="o_conversor" display="o_Conversor"/>] ;
		+ [<memberdata name="o_frm_avance" display="o_Frm_Avance"/>] ;
		+ [<memberdata name="o_fso" display="o_FSO"/>] ;
		+ [<memberdata name="renamefile" display="RenameFile"/>] ;
		+ [<memberdata name="writelog" display="writeLog"/>] ;
		+ [<memberdata name="writelog_flush" display="writeLog_Flush"/>] ;
		+ [</VFPData>]


	*--
	n_FB2PRG_Version		= 1.19
	*--
	c_Foxbin2prg_FullPath	= ''
	c_CurDir				= ''
	c_InputFile				= ''
	c_OriginalFileName		= ''
	c_LogFile				= ''
	c_TextLog				= ''
	c_OutputFile			= ''
	c_Type					= ''
	lFileMode				= .F.
	l_Debug					= .F.
	l_Test					= .F.
	l_ShowErrors			= .F.
	l_ShowProgress			= .T.
	l_Recompile				= .T.
	l_MethodSort_Enabled	= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	l_PropSort_Enabled		= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	l_ReportSort_Enabled	= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	nClassTimeStamp			= ''
	o_Conversor				= NULL
	o_Frm_Avance			= NULL
	o_FSO					= NULL
	c_VC2					= 'VC2'	&& VCX
	c_SC2					= 'SC2'	&& SCX
	c_PJ2					= 'PJ2'	&& PJX
	c_FR2					= 'FR2'	&& FRX
	c_LB2					= 'LB2'	&& LBX
	c_DB2					= 'DB2'	&& DBF
	c_DC2					= 'DC2'	&& DBC
	c_MN2					= 'MN2'	&& MNX


	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF
		SET POINT TO '.'
		SET SEPARATOR TO ','
		THIS.c_Foxbin2prg_FullPath	= SUBSTR( SYS(16), AT( 'C_FOXBIN2PRG.INIT', SYS(16) ) + LEN('C_FOXBIN2PRG.INIT') + 1 )
		THIS.c_CurDir				= SYS(5) + CURDIR()
		THIS.o_FSO					= NEWOBJECT("Scripting.FileSystemObject")
		ADDPROPERTY(_SCREEN, 'ExitCode', 0)
	ENDPROC


	PROCEDURE DESTROY
		TRY
			LOCAL lcFileCDX
			lcFileCDX	= FORCEPATH( "TABLABIN.CDX", JUSTPATH(THIS.c_InputFile) )

			IF FILE( lcFileCDX )
				ERASE ( lcFileCDX )
			ENDIF

			THIS.writeLog_Flush()
		CATCH
		ENDTRY

	ENDPROC


	PROCEDURE doBackup
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toEx						(@? IN    ) Objeto Exception con informaci�n del error
		* tlRelanzarError			(v? IN    ) Indica si se debe relanzar el error
		* tcBakFile_1				(@?    OUT) Nombre del archivo backup 1 (vcx,scx,pjx,frx,lbx,dbf,dbc,mnx,vc2,sc2,pj2,etc)
		* tcBakFile_2				(@?    OUT) Nombre del archivo backup 2 (vct,sct,pjt,frt,lbt,fpt,dct,mnt,etc)
		* tcBakFile_3				(@?    OUT) Nombre del archivo backup 1 (vcx,scx,pjx,cdx,dcx,etc)
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toEx, tlRelanzarError, tcBakFile_1, tcBakFile_2, tcBakFile_3

		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcNext_Bak, lcExt_1, lcExt_2, lcExt_3
			STORE '' TO tcBakFile_1, tcBakFile_2, tcBakFile_3
			lcNext_Bak	= THIS.getNext_BAK( THIS.c_OutputFile )
			lcExt_1		= JUSTEXT( THIS.c_OutputFile )
			tcBakFile_1	= FORCEEXT(THIS.c_OutputFile, lcExt_1 + lcNext_Bak)

			DO CASE
			CASE INLIST( lcExt_1, THIS.c_PJ2, THIS.c_VC2, THIS.c_SC2, THIS.c_FR2 ;
					, THIS.c_LB2, THIS.c_DB2, THIS.c_DC2, THIS.c_MN2, 'PJM' )
				*-- Extensiones TEXTO

			CASE lcExt_1 = 'DBF'
				*-- DBF
				lcExt_2		= 'FPT'
				lcExt_3		= 'CDX'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)
				tcBakFile_3	= FORCEEXT(THIS.c_OutputFile, lcExt_3 + lcNext_Bak)

			CASE lcExt_1 = 'DBC'
				*-- DBC
				lcExt_2		= 'DCT'
				lcExt_3		= 'DCX'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)
				tcBakFile_3	= FORCEEXT(THIS.c_OutputFile, lcExt_3 + lcNext_Bak)

			OTHERWISE
				*-- PJX, VCX, SCX, FRX, LBX, MNX
				lcExt_2		= LEFT(lcExt_1,2) + 'T'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)

			ENDCASE

			IF NOT EMPTY(lcExt_1) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_1) )
				*-- LOG
				DO CASE
				CASE EMPTY(lcExt_2)
					THIS.writeLog( C_BACKUP_OF_LOC + FORCEEXT(THIS.c_OutputFile,lcExt_1) )
				CASE EMPTY(lcExt_3)
					THIS.writeLog( C_BACKUP_OF_LOC + FORCEEXT(THIS.c_OutputFile,lcExt_1) + '/' + lcExt_2 )
				OTHERWISE
					THIS.writeLog( C_BACKUP_OF_LOC + FORCEEXT(THIS.c_OutputFile,lcExt_1) + '/' + lcExt_2 + '/' + lcExt_3 )
				ENDCASE

				*-- COPIA BACKUP
				COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_1) ) TO ( tcBakFile_1 )

				IF NOT EMPTY(lcExt_2) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_2) )
					COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_2) ) TO ( tcBakFile_2 )
				ENDIF

				IF NOT EMPTY(lcExt_3) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_3) )
					COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_3) ) TO ( tcBakFile_3 )
				ENDIF
			ENDIF

		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			IF tlRelanzarError
				THROW
			ENDIF

		ENDTRY

		RETURN
	ENDPROC


	PROCEDURE cargar_frm_avance
		THIS.o_Frm_Avance	= CREATEOBJECT("frm_avance")
	ENDPROC


	PROCEDURE ejecutar
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_InputFile				(!v IN    ) Nombre del archivo de entrada
		* tcType_na					(?v IN    ) NO DISPONIBLE. Se mantiene por compatibilidad con SourceSafe
		* tcTextName_na				(?v IN    ) NO DISPONIBLE. Se mantiene por compatibilidad con SourceSafe
		* tlGenText_na				(?v IN    ) NO DISPONIBLE. Se mantiene por compatibilidad con SourceSafe
		* tcDontShowErrors			(?v IN    ) '1' para no mostrar mensajes de error (MESSAGEBOX)
		* tcDebug					(?v IN    ) '1' para habilitar modo debug (SOLO DESARROLLO)
		* tcDontShowProgress		(?v IN    ) '1' para inhabilitar la barra de progreso
		* toModulo					(?@    OUT) Referencia de objeto del m�dulo generado (para Unit Testing)
		* toEx						(?@    OUT) Objeto con informaci�n del error
		* tlRelanzarError			(?v IN    ) Indica si el error debe relanzarse o no
		* tcOriginalFileName		(v? IN    ) Sirve para los casos en los que inputFile es un nombre temporal y se quiere generar
		*							            el nombre correcto dentro de la versi�n texto (por ej: en los PJ2 y las cabeceras)
		* tcRecompile				(v? IN    ) Indica recompilar ('1') el binario una vez regenerado. [Cambio de funcionamiento por defecto]
		*										Este cambio es para ganar tiempo, velocidad y seguridad. Adem�s la recompilaci�n que hace FoxBin2Prg
		*										se hace desde el directorio del archivo, con lo que las referencias relativas pueden
		*										generar errores de compilaci�n, t�picamente los #include.
		*										NOTA: Si en vez de '1' se indica un Path (p.ej, el del proyecto, se usar� como base para recompilar
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tc_InputFile, tcType_na, tcTextName_na, tlGenText_na, tcDontShowErrors, tcDebug, tcDontShowProgress ;
			, toModulo, toEx AS EXCEPTION, tlRelanzarError, tcOriginalFileName, tcRecompile

		TRY
			LOCAL I, lcPath, lnResp, lcFileSpec, lcFile, laFiles(1,5), laConfig(1), lcConfigFile, lcExt ;
				, llExisteConfig, lcConfData, lnFileCount ;
				, loEx AS EXCEPTION ;
				, loFSO AS Scripting.FileSystemObject

			lnResp	= 0

			SET DELETED ON
			SET DATE YMD
			SET HOURS TO 24
			SET CENTURY ON
			SET SAFETY OFF
			SET TABLEPROMPT OFF

			IF _VFP.STARTMODE > 0
				SET ESCAPE OFF
			ENDIF

			loFSO	= THIS.o_FSO

			DO CASE
			CASE VERSION(5) < 900
				*-- '�FOXBIN2PRG es solo para Visual FoxPro 9.0!'
				MESSAGEBOX( C_FOXBIN2PRG_JUST_VFP_9_LOC, 0+64+4096, C_FOXBIN2PRG_WARN_CAPTION_LOC, 60000 )
				lnResp	= 1

			CASE EMPTY(tc_InputFile)
				*-- (Ejemplo de sintaxis y uso)
				MESSAGEBOX( FOXBIN2PRG_INFO_SINTAX_LOC, 0+64+4096, 'FOXBIN2PRG: SINTAXIS INFO', 60000 )
				lnResp	= 1

			OTHERWISE
				*-- Ejecuci�n normal
				THIS.l_ShowProgress		= NOT (TRANSFORM(tcDontShowProgress)=='1')
				THIS.l_ShowErrors		= NOT (TRANSFORM(tcDontShowErrors) == '1')
				THIS.l_Recompile		= (NOT EMPTY(tcRecompile) AND (TRANSFORM(tcRecompile) == '1' OR DIRECTORY(tcRecompile)))
				THIS.l_Debug			= (TRANSFORM(tcDebug)=='1' OR FILE(FORCEEXT(THIS.c_Foxbin2prg_FullPath,'LOG')))

				IF THIS.l_ShowProgress
					THIS.cargar_frm_avance()
				ENDIF

				*-- Configuraci�n
				lcConfigFile	= FORCEEXT( THIS.c_Foxbin2prg_FullPath, 'CFG' )
				llExisteConfig	= FILE( lcConfigFile )

				IF llExisteConfig
					FOR I = 1 TO ALINES( laConfig, FILETOSTR( lcConfigFile ), 1+4 )
						IF LOWER( LEFT( laConfig(I), 10 ) ) == 'extension:'
							lcConfData	= ALLTRIM( SUBSTR( laConfig(I), 11 ) )
							lcExt		= 'c_' + ALLTRIM( GETWORDNUM( lcConfData, 1, '=' ) )
							IF PEMSTATUS( THIS, lcExt, 5 )
								THIS.ADDPROPERTY( lcExt, UPPER( ALLTRIM( GETWORDNUM( lcConfData, 2, '=' ) ) ) )
							ENDIF
						ENDIF
					ENDFOR
				ENDIF


				*-- Evaluaci�n de FileSpec de entrada
				DO CASE
				CASE '*' $ JUSTEXT( tc_InputFile ) OR '?' $ JUSTEXT( tc_InputFile )
					IF THIS.l_ShowErrors
						MESSAGEBOX( ASTERISK_EXT_NOT_ALLOWED_LOC, 0+48+4096, 'FOXBIN2PRG: ERROR!!', 60000 )
					ELSE
						ERROR ASTERISK_EXT_NOT_ALLOWED_LOC
					ENDIF

				CASE '*' $ JUSTSTEM( tc_InputFile )
					*-- SE QUIEREN TODOS LOS ARCHIVOS DE UNA EXTENSI�N
					lcFileSpec	= FULLPATH( tc_InputFile )

					IF THIS.l_Recompile AND LEN(tcRecompile) > 3 AND DIRECTORY(tcRecompile)
						CD (tcRecompile)
					ELSE
						CD (JUSTPATH(lcFileSpec))
					ENDIF
					THIS.c_LogFile	= ADDBS( JUSTPATH( lcFileSpec ) ) + STRTRAN( JUSTFNAME( lcFileSpec ), '*', '_ALL' ) + '.LOG'

					IF THIS.l_Debug
						IF FILE( THIS.c_LogFile )
							ERASE ( THIS.c_LogFile )
						ENDIF
						THIS.writeLog( THIS.c_Foxbin2prg_FullPath + ' - FileSpec: ' + EVL(tc_InputFile,'') )
						IF llExisteConfig
							THIS.writeLog( 'ConfigFile: ' + lcConfigFile )
						ENDIF
					ENDIF

					lnFileCount	= ADIR( laFiles, lcFileSpec, '', 1 )

					IF THIS.l_ShowProgress
						THIS.o_Frm_Avance.nMAX_VALUE	= lnFileCount
					ENDIF

					FOR I = 1 TO lnFileCount
						lcFile	= FORCEPATH( laFiles(I,1), JUSTPATH( lcFileSpec ) )
						THIS.o_Frm_Avance.lbl_TAREA.CAPTION = C_PROCESSING_LOC + lcFile + '...'
						THIS.o_Frm_Avance.nVALUE = I

						IF THIS.l_ShowProgress
							THIS.o_Frm_Avance.SHOW()
						ENDIF

						IF FILE( lcFile )
							lnResp = THIS.Convertir( lcFile, toModulo, toEx, tlRelanzarError, tcOriginalFileName )
						ENDIF
					ENDFOR

				OTHERWISE
					*-- UN ARCHIVO INDIVIDUAL
					IF FILE(tc_InputFile)

						IF THIS.l_Recompile AND LEN(tcRecompile) > 3 AND DIRECTORY(tcRecompile)
							CD (tcRecompile)
						ELSE
							CD (JUSTPATH(tc_InputFile))
						ENDIF

						THIS.c_LogFile	= tc_InputFile + '.LOG'

						IF THIS.l_Debug
							IF FILE( THIS.c_LogFile )
								ERASE ( THIS.c_LogFile )
							ENDIF
							THIS.writeLog( THIS.c_Foxbin2prg_FullPath + ' - FileSpec: ' + EVL(tc_InputFile,'') )
						ENDIF

						lnResp = THIS.Convertir( tc_InputFile, toModulo, toEx, tlRelanzarError, tcOriginalFileName )
					ENDIF
				ENDCASE

			ENDCASE

		CATCH TO toEx
			ADDPROPERTY(_SCREEN, 'ExitCode', toEx.ERRORNO)
			IF llExisteConfig
				THIS.writeLog( 'ERROR: ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CR_LF ;
					+ toEx.PROCEDURE + ', line ' + TRANSFORM(toEx.LINENO) + CR_LF ;
					+ toEx.DETAILS )
			ENDIF
			IF tlRelanzarError
				THROW
			ENDIF

		FINALLY
			IF THIS.l_ShowProgress
				THIS.o_Frm_Avance.HIDE()
				THIS.o_Frm_Avance.RELEASE()
				STORE NULL TO THIS.o_Frm_Avance
			ENDIF
			CD (JUSTPATH(THIS.c_CurDir))
			*SET PATH TO (lcPath)
		ENDTRY

		RETURN lnResp
	ENDPROC


	PROCEDURE Convertir
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_InputFile				(!v IN    ) Nombre del archivo de entrada
		* toModulo					(?@    OUT) Referencia de objeto del m�dulo generado (para Unit Testing)
		* toEx						(?@    OUT) Objeto con informaci�n del error
		* tlRelanzarError			(?v IN    ) Indica si el error debe relanzarse o no
		* tcOriginalFileName		(v? IN    ) Sirve para los casos en los que inputFile es un nombre temporal y se quiere generar
		*							            el nombre correcto dentro de la versi�n texto (por ej: en los PJ2 y las cabeceras)
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tc_InputFile, toModulo, toEx AS EXCEPTION, tlRelanzarError, tcOriginalFileName

		TRY
			LOCAL lnCodError, lcErrorInfo, laDirFile(1,5), lcExtension ;
				, loFSO AS Scripting.FileSystemObject
			lnCodError			= 0

			WITH THIS AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
				loFSO			= THIS.o_FSO
				.c_InputFile	= FULLPATH( tc_InputFile )

				IF ADIR( laDirFile, .c_InputFile, '', 1 ) = 0
					ERROR 'No se encontr� el archivo [' + .c_InputFile + ']'
				ENDIF

				.c_InputFile	= loFSO.GetAbsolutePathName( FORCEPATH( laDirFile(1,1), JUSTPATH(.c_InputFile) ) )

				IF NOT EMPTY(tcOriginalFileName)
					tcOriginalFileName	= loFSO.GetAbsolutePathName( tcOriginalFileName )
				ENDIF

				.c_OriginalFileName	= EVL( tcOriginalFileName, .c_InputFile )

				IF UPPER( JUSTEXT(.c_OriginalFileName) ) = 'PJM'
					.c_OriginalFileName	= FORCEEXT(.c_OriginalFileName,'pjx')
				ENDIF

				THIS.writeLog( 'c_InputFile=' + .c_InputFile )
				.o_Conversor	= NULL

				IF NOT FILE(.c_InputFile)
					ERROR C_FILE_DOESNT_EXIST_LOC + ' [' + .c_InputFile + ']'
				ENDIF

				IF FILE( .c_InputFile + '.ERR' )
					TRY
						ERASE ( .c_InputFile + '.ERR' )
					CATCH
					ENDTRY
				ENDIF

				lcExtension	= UPPER( JUSTEXT(.c_InputFile) )

				DO CASE
				CASE lcExtension = 'VCX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_VC2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_vcx_a_prg' )

				CASE lcExtension = 'SCX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_SC2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_scx_a_prg' )

				CASE lcExtension = 'PJX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_PJ2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_pjx_a_prg' )

				CASE lcExtension = 'PJM'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_PJ2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_pjm_a_prg' )

				CASE lcExtension = 'FRX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_FR2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_frx_a_prg' )

				CASE lcExtension = 'LBX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_LB2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_frx_a_prg' )

				CASE lcExtension = 'DBF'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_DB2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_dbf_a_prg' )

				CASE lcExtension = 'DBC'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_DC2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_dbc_a_prg' )

				CASE lcExtension = 'MNX'
					.c_OutputFile	= FORCEEXT( .c_InputFile, .c_MN2 )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_mnx_a_prg' )

				CASE lcExtension = .c_VC2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'VCX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_vcx' )

				CASE lcExtension = .c_SC2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'SCX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_scx' )

				CASE lcExtension = .c_PJ2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'PJX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_pjx' )

				CASE lcExtension = .c_FR2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'FRX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_frx' )

				CASE lcExtension = .c_LB2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'LBX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_frx' )

				CASE lcExtension = .c_DB2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'DBF' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_dbf' )

				CASE lcExtension = .c_DC2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'DBC' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_dbc' )

				CASE lcExtension = .c_MN2
					.c_OutputFile	= FORCEEXT( .c_InputFile, 'MNX' )
					.o_Conversor	= CREATEOBJECT( 'c_conversor_prg_a_mnx' )

				OTHERWISE
					ERROR 'El archivo [' + .c_InputFile + '] no est� soportado'

				ENDCASE

				.c_Type								= UPPER(JUSTEXT(.c_OutputFile))
				.o_Conversor.c_InputFile			= .c_InputFile
				.o_Conversor.c_OutputFile			= .c_OutputFile
				.o_Conversor.c_LogFile				= .c_LogFile
				.o_Conversor.l_Debug				= .l_Debug
				.o_Conversor.l_Test					= .l_Test
				.o_Conversor.n_FB2PRG_Version		= .n_FB2PRG_Version
				.o_Conversor.l_MethodSort_Enabled	= .l_MethodSort_Enabled
				.o_Conversor.l_PropSort_Enabled		= .l_PropSort_Enabled
				.o_Conversor.l_ReportSort_Enabled	= .l_ReportSort_Enabled
				.o_Conversor.c_OriginalFileName		= .c_OriginalFileName
				.o_Conversor.c_Foxbin2prg_FullPath	= .c_Foxbin2prg_FullPath
				*--
				.o_Conversor.Convertir( @toModulo, .F., THIS )
				.c_TextLog	= .c_TextLog + CR_LF + .o_Conversor.c_TextLog	&& Recojo el LOG que haya generado el conversor
				.normalizarCapitalizacionArchivos()
			ENDWITH &&	THIS AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'

		CATCH TO toEx
			lnCodError	= toEx.ERRORNO
			lcErrorInfo	= THIS.Exception2Str(toEx) + CR_LF + CR_LF + C_SOURCEFILE_LOC + THIS.c_InputFile

			TRY
				STRTOFILE( lcErrorInfo, THIS.c_InputFile + '.ERR' )
			CATCH TO loEx2
			ENDTRY

			IF THIS.l_Debug
				IF _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF
				THIS.writeLog( lcErrorInfo )
			ENDIF
			IF THIS.l_Debug AND THIS.l_ShowErrors
				MESSAGEBOX( lcErrorInfo, 0+16+4096, 'FOXBIN2PRG: ERROR!!', 60000 )
			ENDIF
			IF tlRelanzarError	&& Usado en Unit Testing
				THROW
			ENDIF

		FINALLY
			loFSO				= NULL
			THIS.o_Conversor	= NULL
			THIS.writeLog_Flush()

		ENDTRY

		RETURN lnCodError
	ENDPROC


	PROCEDURE get_PROGRAM_HEADER
		LOCAL lcText
		lcText	= ''

		*-- Cabecera del PRG e inicio de DEF_CLASS
		TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			* (ES) AUTOGENERADO - ��ATENCI�N!! - ��NO PENSADO PARA EJECUTAR!! USAR SOLAMENTE PARA INTEGRAR CAMBIOS Y ALMACENAR CON HERRAMIENTAS SCM!!
			* (EN) AUTOGENERATED - ATTENTION!! - NOT INTENDED FOR EXECUTION!! USE ONLY FOR MERGING CHANGES AND STORING WITH SCM TOOLS!!
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			<<C_FB2PRG_META_I>> Version="<<TRANSFORM(THIS.n_FB2PRG_Version)>>" SourceFile="<<EVL( THIS.c_OriginalFileName, THIS.c_InputFile )>>" <<C_FB2PRG_META_F>> (Solo para binarios VFP 9 / Only for VFP 9 binaries)
			*
		ENDTEXT

		RETURN lcText
	ENDPROC


	PROCEDURE getNext_BAK
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFilename			(!v IN    ) Nombre del archivo de salida a crear el backup
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcOutputFileName
		LOCAL lcNext_Bak, I
		lcNext_Bak = ''

		FOR I = 0 TO 99
			IF I = 0
				IF NOT FILE( tcOutputFileName + '.BAK' )
					lcNext_Bak	= '.BAK'
					EXIT
				ENDIF
			ELSE
				IF NOT FILE( tcOutputFileName + '.' + PADL(I,2,'0') + '.BAK' )
					lcNext_Bak	= '.' + PADL(I,2,'0') + '.BAK'
					EXIT
				ENDIF
			ENDIF
		ENDFOR

		lcNext_Bak	= EVL( lcNext_Bak, '.100.BAK' )	&& Para que no quede nunca vac�o

		RETURN lcNext_Bak
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarCapitalizacionArchivos
		TRY
			LOCAL lcPath, lcEXE_CAPS, lcOutputFile ;
				, loFSO AS Scripting.FileSystemObject
			lcPath		= JUSTPATH(THIS.c_Foxbin2prg_FullPath)
			lcEXE_CAPS	= FORCEPATH( 'filename_caps.exe', lcPath )
			loFSO		= THIS.o_FSO

			IF FILE(lcEXE_CAPS)
				THIS.writeLog( '* Se ha encontrado el programa de capitalizaci�n de nombres [' + lcEXE_CAPS + ']' )
			ELSE
				*-- No existe el programa de capitalizaci�n, as� que no se capitalizan los nombres.
				THIS.writeLog( '* No se ha encontrado el programa de capitalizaci�n de nombres [' + lcEXE_CAPS + ']' )
				EXIT
			ENDIF

			THIS.RenameFile( THIS.c_OutputFile, lcEXE_CAPS, loFSO )

			DO CASE
			CASE THIS.c_Type = 'PJX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'PJT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'VCX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'VCT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'SCX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'SCT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'FRX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'FRT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'LBX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'LBT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'DBF'
				IF FILE( FORCEEXT(THIS.c_OutputFile,'FPT') )
					THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'FPT'), lcEXE_CAPS, loFSO )
				ENDIF
				IF FILE( FORCEEXT(THIS.c_OutputFile,'CDX') )
					THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'CDX'), lcEXE_CAPS, loFSO )
				ENDIF

			CASE THIS.c_Type = 'DBC'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'DCX'), lcEXE_CAPS, loFSO )
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'DCT'), lcEXE_CAPS, loFSO )

			CASE THIS.c_Type = 'MNX'
				THIS.RenameFile( FORCEEXT(THIS.c_OutputFile,'MNT'), lcEXE_CAPS, loFSO )

			ENDCASE
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE RenameFile
		LPARAMETERS tcFileName, tcEXE_CAPS, toFSO AS Scripting.FileSystemObject

		LOCAL lcLog, laFile(1,5)
		THIS.writeLog( '- Se ha solicitado capitalizar el archivo [' + tcFileName + ']' )
		lcLog	= ''
		DO (tcEXE_CAPS) WITH tcFileName, '', 'F', lcLog, .T.
		*IF ADIR( laFile, tcFileName, '', 1 ) > 0 AND laFile(1,1) <> JUSTFNAME(tcFileName)
		*	toFSO.MoveFile( FORCEPATH( laFile(1,1), JUSTPATH(tcFileName) ), tcFileName )
		*	THIS.writeLog( '  => Se renombrar� a [' + tcFileName + ']' )
		*ELSE
		*	THIS.writeLog( '  => No se renombrar� a [' + tcFileName + '] porque ya estaba correcto.' )
		*ENDIF
		THIS.writeLog( lcLog )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE writeLog
		LPARAMETERS tcText

		TRY
			THIS.c_TextLog	= THIS.c_TextLog + TTOC(DATETIME(),3) + '  ' + EVL(tcText,'') + CR_LF
		CATCH
		ENDTRY
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE writeLog_Flush
		IF THIS.l_Debug AND NOT EMPTY(THIS.c_TextLog)
			STRTOFILE( THIS.c_TextLog + CR_LF, THIS.c_LogFile, 1 )
			THIS.c_TextLog	= ''
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	HIDDEN PROCEDURE Exception2Str
		LPARAMETERS toEx AS EXCEPTION
		LOCAL lcError
		lcError		= 'Error ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CR_LF ;
			+ toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) + CR_LF ;
			+ toEx.LINECONTENTS + CR_LF + CR_LF ;
			+ EVL(toEx.USERVALUE,'')
		RETURN lcError
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS frm_avance AS FORM
	HEIGHT = 79
	WIDTH = 628
	SHOWWINDOW = 2
	DOCREATE = .T.
	AUTOCENTER = .T.
	BORDERSTYLE = 2
	CAPTION = C_PROCESS_PROGRESS_LOC
	CONTROLBOX = .F.
	BACKCOLOR = RGB(255,255,255)
	nMAX_VALUE = 100
	nVALUE = 0
	NAME = "FRM_AVANCE"


	ADD OBJECT shp_base AS SHAPE WITH ;
		TOP = 50, ;
		LEFT = 12, ;
		HEIGHT = 13, ;
		WIDTH = 601, ;
		CURVATURE = 15, ;
		NAME = "shp_base"


	ADD OBJECT shp_avance AS SHAPE WITH ;
		TOP = 50, ;
		LEFT = 12, ;
		HEIGHT = 13, ;
		WIDTH = 36, ;
		CURVATURE = 15, ;
		BACKCOLOR = RGB(255,255,128), ;
		BORDERCOLOR = RGB(255,0,0), ;
		NAME = "shp_Avance"


	ADD OBJECT lbl_TAREA AS LABEL WITH ;
		BACKSTYLE = 0, ;
		CAPTION = ".", ;
		HEIGHT = 17, ;
		LEFT = 12, ;
		TOP = 20, ;
		WIDTH = 604, ;
		NAME = "lbl_Tarea"


	PROCEDURE nvalue_assign
		LPARAMETERS vNewVal

		WITH THIS
			.nVALUE = m.vNewVal
			.shp_avance.WIDTH = m.vNewVal * .shp_base.WIDTH / .nMAX_VALUE
		ENDWITH
	ENDPROC


	PROCEDURE INIT
		THIS.nVALUE = 0
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_base AS SESSION
	#IF .F.
		LOCAL THIS AS c_conversor_base OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarasignacion_tag_indicado" display="analizarAsignacion_TAG_Indicado"/>] ;
		+ [<memberdata name="buscarobjetodelmetodopornombre" display="buscarObjetoDelMetodoPorNombre"/>] ;
		+ [<memberdata name="comprobarexpresionvalida" display="comprobarExpresionValida"/>] ;
		+ [<memberdata name="convertir" display="Convertir"/>] ;
		+ [<memberdata name="decode_specialcodes_1_31" display="decode_SpecialCodes_1_31"/>] ;
		+ [<memberdata name="desnormalizarasignacion" display="desnormalizarAsignacion"/>] ;
		+ [<memberdata name="desnormalizarvalorpropiedad" display="desnormalizarValorPropiedad"/>] ;
		+ [<memberdata name="desnormalizarvalorxml" display="desnormalizarValorXML"/>] ;
		+ [<memberdata name="encode_specialcodes_1_31" display="encode_SpecialCodes_1_31"/>] ;
		+ [<memberdata name="exception2str" display="Exception2Str"/>] ;
		+ [<memberdata name="filetypecode" display="fileTypeCode"/>] ;
		+ [<memberdata name="get_separatedlineandcomment" display="get_SeparatedLineAndComment"/>] ;
		+ [<memberdata name="get_separatedpropandvalue" display="get_SeparatedPropAndValue"/>] ;
		+ [<memberdata name="get_valuefromnullterminatedvalue" display="get_ValueFromNullTerminatedValue"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="lineisonlycommentandnometadata" display="lineIsOnlyCommentAndNoMetadata"/>] ;
		+ [<memberdata name="normalizarasignacion" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="normalizarvalorpropiedad" display="normalizarValorPropiedad"/>] ;
		+ [<memberdata name="normalizarvalorxml" display="normalizarValorXML"/>] ;
		+ [<memberdata name="sortpropsandvalues" display="sortPropsAndValues"/>] ;
		+ [<memberdata name="sortpropsandvalues_setandgetscxpropnames" type="method" display="sortPropsAndValues_SetAndGetSCXPropNames"/>] ;
		+ [<memberdata name="writelog" display="writeLog"/>] ;
		+ [<memberdata name="c_curdir" display="c_CurDir"/>] ;
		+ [<memberdata name="c_foxbin2prg_fullpath" display="c_Foxbin2prg_FullPath"/>] ;
		+ [<memberdata name="c_inputfile" display="c_InputFile"/>] ;
		+ [<memberdata name="c_logfile" display="c_LogFile"/>] ;
		+ [<memberdata name="c_originalfilename" display="c_OriginalFileName"/>] ;
		+ [<memberdata name="c_outputfile" display="c_OutputFile"/>] ;
		+ [<memberdata name="c_textlog" display="c_TextLog"/>] ;
		+ [<memberdata name="c_type" display="c_Type"/>] ;
		+ [<memberdata name="l_debug" display="l_Debug"/>] ;
		+ [<memberdata name="l_test" display="l_Test"/>] ;
		+ [<memberdata name="l_methodsort_enabled" display="l_MethodSort_Enabled"/>] ;
		+ [<memberdata name="l_propsort_enabled" display="l_PropSort_Enabled"/>] ;
		+ [<memberdata name="l_reportsort_enabled" display="l_ReportSort_Enabled"/>] ;
		+ [<memberdata name="n_fb2prg_version" display="n_FB2PRG_Version"/>] ;
		+ [<memberdata name="ofso" display="oFSO"/>] ;
		+ [</VFPData>]


	l_Debug					= .F.
	l_Test					= .F.
	c_InputFile				= ''
	c_OutputFile			= ''
	lFileMode				= .F.
	nClassTimeStamp			= ''
	n_FB2PRG_Version		= 1.0
	c_Foxbin2prg_FullPath	= ''
	c_Type					= ''
	c_CurDir				= ''
	c_LogFile				= ''
	c_TextLog				= ''
	l_MethodSort_Enabled	= .T.
	l_PropSort_Enabled		= .T.
	l_ReportSort_Enabled	= .T.
	c_OriginalFileName		= ''
	oFSO					= NULL


	*******************************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		PUBLIC C_FB2PRG_CODE
		C_FB2PRG_CODE	= ''	&& Contendr� todo el c�digo generado
		THIS.c_CurDir	= SYS(5) + CURDIR()
		THIS.oFSO		= CREATEOBJECT( "Scripting.FileSystemObject")
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		C_FB2PRG_CODE	= ''
		USE IN (SELECT("TABLABIN"))

		THIS.writeLog( C_CONVERTER_UNLOAD_LOC )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarAsignacion_TAG_Indicado
		*-- DETALLES: Este m�todo est� pensado para leer los tags FB2P_VALUE y MEMBERDATA, que tienen esta sintaxis:
		*
		*	_memberdata = <VFPData>
		*		<memberdata name="mimetodo" display="miMetodo"/>
		*		</VFPData>		&& XML Metadata for customizable properties
		*
		*	<fb2p_value>Este es un&#13;valor especial</fb2p_value>
		*
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcPropName				(!v IN    ) Nombre de la propiedad
		* tcValue					(!v IN    ) Valor (o inicio del valor) de la propiedad
		* taProps					(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnProp_Count				(!@ IN    ) Cantidad de l�neas de c�digo
		* I							(!@ IN    ) L�nea actualmente evaluada
		* tcTAG_I					(!v IN    ) TAG de inicio	<tag>
		* tcTAG_F					(!v IN    ) TAG de fin		</tag>
		* tnLEN_TAG_I				(!v IN    ) Longitud del tag de inicio
		* tnLEN_TAG_F				(!v IN    ) Longitud del tag de fin
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcPropName, tcValue, taProps, tnProp_Count, I, tcTAG_I, tcTAG_F, tnLEN_TAG_I, tnLEN_TAG_F
		EXTERNAL ARRAY taProps
		LOCAL llBloqueEncontrado, loEx AS EXCEPTION

		TRY
			IF LEFT( tcValue, tnLEN_TAG_I) == tcTAG_I
				llBloqueEncontrado	= .T.
				LOCAL lcLine, lnArrayCols

				*-- Propiedad especial
				IF tcTAG_F $ tcValue		&& El fin de tag est� "inline"
					THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
					EXIT
				ENDIF

				tcValue			= ''
				lnArrayCols		= ALEN(taProps,2)

				FOR I = I + 1 TO tnProp_Count
					IF lnArrayCols = 0
						lcLine = LTRIM( taProps(I), 0, ' ', CHR(9) )	&& Quito espacios y TABS de la izquierda
					ELSE
						lcLine = LTRIM( taProps(I,1), 0, ' ', CHR(9) )	&& Quito espacios y TABS de la izquierda
					ENDIF

					DO CASE
					CASE LEFT( lcLine, tnLEN_TAG_F ) == tcTAG_F
						*-- <EndTag>
						tcValue	= tcTAG_I + SUBSTR( tcValue, 3 ) + tcTAG_F
						THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
						I = I + 1
						EXIT

					CASE tcTAG_F $ lcLine
						*-- Data-Data-Data-<EndTag>
						tcValue	= tcTAG_I + SUBSTR( tcValue, 3 ) + LEFT( lcLine, AT( tcTAG_F, lcLine )-1 ) + tcTAG_F
						THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
						I = I + 1
						EXIT

					OTHERWISE
						*-- Data
						tcValue	= tcValue + CR_LF + lcLine
					ENDCASE
				ENDFOR

				I = I - 1

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE buscarObjetoDelMetodoPorNombre
		LPARAMETERS tcNombreObjeto, toClase
		*-- Caso 1: Un m�todo de un objeto de la clase
		*-- 	buscarObjetoDelMetodoPorNombre( 'command1', loClase )
		*-- Caso 2: Un m�todo de un objeto heredado que no est� definido en esta librer�a
		*-- 	buscarObjetoDelMetodoPorNombre( 'cnt_descripcion.Cntlista.cmgAceptarCancelar.cmdCancelar', loClase )
		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnObjeto, I, X, N, lcRutaDelNombre ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			STORE 0 TO N, lnObjeto

			*--   El m�todo puede pertenecer a esta clase, a un objeto de esta clase,
			*-- o a un objeto heredado que no est� definido en esta clase, sino en otra,
			*-- y para la cual la ruta a buscar es parcial.
			*--   Por ejemplo, el caso 2 puede que el objeto que hay sea 'cnt_descripcion.Cntlista'
			*-- y el bot�n sea heredado, pero se le haya redefinido su m�todo Click aqu�.
			FOR X = OCCURS( '.', tcNombreObjeto + '.' ) TO 1 STEP -1
				N	= N + 1
				lcRutaDelNombre	= LEFT( tcNombreObjeto, RAT( '.', tcNombreObjeto + '.', N ) - 1 )
				FOR I = 1 TO toClase._AddObject_Count
					loObjeto	= toClase._AddObjects(I)

					*-- Busco tanto el [nombre] del m�todo como [class.nombre]+[nombre] del m�todo
					IF LOWER(loObjeto._Nombre) == LOWER(toClase._ObjName) + '.' + lcRutaDelNombre ;
							OR LOWER(loObjeto._Nombre) == lcRutaDelNombre
						lnObjeto	= I
						EXIT
					ENDIF
				ENDFOR
				IF lnObjeto > 0
					EXIT
				ENDIF
			ENDFOR

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnObjeto
	ENDPROC


	*******************************************************************************************************************
	FUNCTION comprobarExpresionValida
		LPARAMETERS tcAsignacion, tnCodError, tcExpNormalizada
		LOCAL llError, loEx AS EXCEPTION

		TRY
			tcExpNormalizada	= NORMALIZE( tcAsignacion )

		CATCH TO loEx
			llError		= .T.
			tnCodError	= loEx.ERRORNO
		ENDTRY

		RETURN NOT llError
	ENDFUNC


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase correspondiente con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		THIS.writeLog( '' )
		THIS.writeLog( C_CONVERTING_FILE_LOC + THIS.c_OutputFile + '...' )
	ENDPROC


	PROCEDURE decode_SpecialCodes_1_31
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcText					(@! IN    ) Decodifica los primeros 31 caracteres ASCII de {nCode} a CHR(nCode)
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcText
		LOCAL I
		FOR I = 0 TO 31
			tcText	= STRTRAN( tcText, '{' + TRANSFORM(I) + '}', CHR(I) )
		ENDFOR
		RETURN tcText
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE desnormalizarAsignacion
		LPARAMETERS tcAsignacion
		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada, lnPos, lcComentario
		THIS.get_SeparatedPropAndValue( @tcAsignacion, @lcPropName, @lcValor )
		lcComentario	= ''
		THIS.desnormalizarValorPropiedad( @lcPropName, @lcValor, @lcComentario )
		tcAsignacion	= lcPropName + ' = ' + lcValor

		RETURN tcAsignacion
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE desnormalizarValorPropiedad
		LPARAMETERS tcProp, tcValue, tcComentario
		LOCAL lnCodError, lnPos, lcValue
		tcComentario	= ''

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE tcProp == '_memberdata'
			*-- Me quedo con lo importante y quito los CHR(0) y longitud que a veces agrega al inicio
			lcValue	= ''

			FOR I = 1 TO OCCURS( '/>', tcValue )
				TEXT TO lcValue TEXTMERGE ADDITIVE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<STREXTRACT( tcValue, '<memberdata ', '/>', I, 1+4 )>>
				ENDTEXT
			ENDFOR

			TEXT TO tcValue TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<VFPData>
				<<SUBSTR( lcValue, 3)>>
				</VFPData>
			ENDTEXT

			tcValue	= C_MPROPHEADER + STR( LEN(tcValue), 8 ) + tcValue

		CASE LEFT( tcValue, C_LEN_FB2P_VALUE_I ) == C_FB2P_VALUE_I
			*-- Valor especial Fox con cabecera CHR(1): Debo agregarla y desnormalizar el valor
			tcValue	= STRTRAN( STRTRAN( STREXTRACT( tcValue, C_FB2P_VALUE_I, C_FB2P_VALUE_F, 1, 1 ), '&#13;', C_CR ), '&#10;', C_LF  )
			tcValue	= C_MPROPHEADER + STR( LEN(tcValue), 8 ) + tcValue

		ENDCASE

		RETURN tcValue
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE desnormalizarValorXML
		LPARAMETERS tcValor
		*-- DESNORMALIZA EL TEXTO INDICADO, EXPANDIENDO LOS S�MBOLOS XML ESPECIALES.
		LOCAL lnPos, lnPos2, lnAscii
		tcValor	= STRTRAN(tcValor, CHR(38)+'gt;', '>')			&&	>
		tcValor	= STRTRAN(tcValor, CHR(38)+'lt;', '<')			&&	<
		tcValor	= STRTRAN(tcValor, CHR(38)+'quot;', CHR(34))	&&	"
		tcValor	= STRTRAN(tcValor, CHR(38)+'apos;', CHR(39))	&&	'
		tcValor	= STRTRAN(tcValor, CHR(38)+'amp;', CHR(38))		&&	&

		*-- Obtengo los Hex
		DO WHILE .T.
			lnPos	= AT( CHR(38)+'#x', tcValor )
			IF lnPos = 0
				EXIT
			ENDIF
			lnPos2	= lnPos + 1 + AT( ';', SUBSTR( tcValor, lnPos + 2, 4 ) )
			lnAscii	= EVALUATE( '0' + SUBSTR( tcValor, lnPos + 3, lnPos2 - lnPos - 3 ) )
			tcValor	= STUFF(tcValor, lnPos, lnPos2 - lnPos + 1, CHR(lnAscii))		&&	ASCII
		ENDDO

		*-- Obtengo los Dec
		DO WHILE .T.
			lnPos	= AT( CHR(38)+'#', tcValor )
			IF lnPos = 0
				EXIT
			ENDIF
			lnPos2	= lnPos + 1 + AT( ';', SUBSTR( tcValor, lnPos + 2, 4 ) )
			lnAscii	= EVALUATE( SUBSTR( tcValor, lnPos + 2, lnPos2 - lnPos - 2 ) )
			tcValor	= STUFF(tcValor, lnPos, lnPos2 - lnPos + 1, CHR(lnAscii))		&&	ASCII
		ENDDO

		RETURN tcValor
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE encode_SpecialCodes_1_31
		LPARAMETERS tcText
		LOCAL I
		FOR I = 0 TO 31
			tcText	= STRTRAN( tcText, CHR(I), '{' + TRANSFORM(I) + '}' )
		ENDFOR
		RETURN tcText
	ENDPROC


	*******************************************************************************************************************
	HIDDEN PROCEDURE Exception2Str
		LPARAMETERS toEx AS EXCEPTION
		LOCAL lcError
		lcError		= 'Error ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CHR(13) + CHR(13) ;
			+ toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) + CHR(13) + CHR(13) ;
			+ toEx.LINECONTENTS
		RETURN lcError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE fileTypeCode
		LPARAMETERS tcExtension
		tcExtension	= UPPER(tcExtension)
		RETURN ICASE( tcExtension = 'DBC', 'd' ;
			, tcExtension = 'DBF', 'D' ;
			, tcExtension = 'QPR', 'Q' ;
			, tcExtension = 'SCX', 'K' ;
			, tcExtension = 'FRX', 'R' ;
			, tcExtension = 'LBX', 'B' ;
			, tcExtension = 'VCX', 'V' ;
			, tcExtension = 'PRG', 'P' ;
			, tcExtension = 'FLL', 'L' ;
			, tcExtension = 'APP', 'Z' ;
			, tcExtension = 'EXE', 'Z' ;
			, tcExtension = 'MNX', 'M' ;
			, tcExtension = 'TXT', 'T' ;
			, tcExtension = 'FPW', 'T' ;
			, tcExtension = 'H', 'T' ;
			, 'x' )
	ENDPROC


	FUNCTION GetTimeStamp
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tnTimeStamp				(v! IN    ) Timestamp en formato num�rico
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tnTimeStamp
		*-- CONVIERTE UN DATO TIMESTAMP NUMERICO USADO POR LOS ARCHIVOS SCX/VCX/etc. EN TIPO DATETIME
		TRY
			LOCAL lcTimeStamp,lnYear,lnMonth,lnDay,lnHour,lnMinutes,lnSeconds,lcTime,lnHour,ltTimeStamp,lnResto ;
				,lcTimeStamp_Ret, laDir[1,5], loEx AS EXCEPTION

			lcTimeStamp_Ret	= ''

			IF EMPTY(tnTimeStamp)
				IF THIS.lFileMode
					IF ADIR(laDir,THIS.c_InputFile)=0
						EXIT
					ENDIF

					*-- Esto fuerza la conversi�n a formato 12 hs, que no me interesa.
					*lcTime=laDir[1,4]
					*lnHour=VAL(lcTime)
					*IF lnHour<12
					*	lcTime=ALLTRIM(STR(IIF(lnHour=0,12,lnHour),2))+SUBSTR(lcTime,3)+" AM"
					*ELSE
					*	lcTime=ALLTRIM(STR(IIF(lnHour=12,24,lnHour)-12,2))+SUBSTR(lcTime,3)+" PM"
					*ENDIF
					*IF VAL(lcTime)<10
					*	lcTime="0"+lcTime
					*ENDIF
					*lcTimeStamp_Ret	= DTOC(laDir[1,3])+" "+lcTime

					ltTimeStamp	= EVALUATE( '{^' + DTOC(laDir(1,3)) + ' ' + TRANSFORM(laDir(1,4)) + '}' )

					*-- En mi arreglo, si la hora pasada tiene 32 segundos o m�s, redondeo al siguiente minuto, ya que
					*-- la descodificaci�n posterior de GetTimeStamp tiene ese margen de error.
					IF SEC(m.ltTimeStamp) >= 32
						ltTimeStamp	= m.ltTimeStamp + 28
					ENDIF

					lcTimeStamp_Ret	= TTOC( ltTimeStamp )
					EXIT
				ENDIF

				tnTimeStamp = THIS.nClassTimeStamp

				IF EMPTY(tnTimeStamp)
					EXIT
				ENDIF
			ENDIF

			*-- YYYY YYYM MMMD DDDD HHHH HMMM MMMS SSSS
			lnResto		= tnTimeStamp
			lnYear		= INT( lnResto / 2**25 + 1980)
			lnResto		= lnResto % 2**25
			lnMonth		= INT( lnResto / 2**21 )
			lnResto		= lnResto % 2**21
			lnDay		= INT( lnResto / 2**16 )
			lnResto		= lnResto % 2**16
			lnHour		= INT( lnResto / 2**11 )
			lnResto		= lnResto % 2**11
			lnMinutes	= INT( lnResto / 2**5 )
			lnResto		= lnResto % 2**5
			lnSeconds	= lnResto

			lcTimeStamp	= STR(lnYear,4) + "/" + STR(lnMonth,2) + "/" + STR(lnDay,2) + " " ;
				+ STR(lnHour,2) + ":" + STR(lnMinutes,2) + ":" + STR(lnSeconds,2)

			ltTimeStamp	= EVALUATE( "{^" + lcTimeStamp + "}" )

			lcTimeStamp_Ret	= TTOC( ltTimeStamp )

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcTimeStamp_Ret
	ENDPROC


	PROCEDURE get_SeparatedLineAndComment
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) L�nea a separar del comentario
		* tcComment					(@?    OUT) Comentario
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, tcComment
		LOCAL ln_AT_Cmt
		tcComment	= ''

		IF '&'+'&' $ tcLine
			ln_AT_Cmt	= AT( '&'+'&', tcLine)
			tcComment	= LTRIM( SUBSTR( tcLine, ln_AT_Cmt + 2 ) )
			tcLine		= RTRIM( LEFT( tcLine, ln_AT_Cmt - 1 ), 0, ' ', CHR(9) )	&& Quito espacios y TABS
		ENDIF

		RETURN
	ENDPROC


	PROCEDURE get_SeparatedPropAndValue
		*-- Devuelve el valor separado de la propiedad.
		*-- Si se indican m�s de 3 par�metros, eval�a el valor completo a trav�s de las l�neas de c�digo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusi�n
		* toModulo					(?@    OUT) Objeto con toda la informaci�n del m�dulo analizado
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcAsignacion, tcPropName, tcValue, toClase, taCodeLines, tnCodeLines, I
		LOCAL ln_AT_Cmt
		STORE '' TO tcPropName, tcValue

		*-- EVALUAR UNA ASIGNACI�N ESPEC�FICA INLINE
		IF '=' $ tcAsignacion
			ln_AT_Cmt	= AT( '=', tcAsignacion)
			tcPropName	= ALLTRIM( LEFT( tcAsignacion, ln_AT_Cmt - 2 ), 0, ' ', CHR(9) )	&& Quito espacios y TABS
			tcValue		= ALLTRIM( SUBSTR( tcAsignacion, ln_AT_Cmt + 2 ) )

			IF PCOUNT() > 3
				*-- EVALUAR UNA ASIGNACI�N QUE PUEDE SER MULTIL�NEA (memberdata, fb2p_value, etc)
				DO CASE
				CASE THIS.analizarAsignacion_TAG_Indicado( @tcPropName, @tcValue, @taCodeLines, tnCodeLines, @I ;
						, C_FB2P_VALUE_I, C_FB2P_VALUE_F, C_LEN_FB2P_VALUE_I, C_LEN_FB2P_VALUE_F )
					*-- FB2P_VALUE

				CASE THIS.analizarAsignacion_TAG_Indicado( @tcPropName, @tcValue, @taCodeLines, tnCodeLines, @I ;
						, C_MEMBERDATA_I, C_MEMBERDATA_F, C_LEN_MEMBERDATA_I, C_LEN_MEMBERDATA_F )
					*-- MEMBERDATA

				OTHERWISE
					*-- Propiedad normal
					THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )

				ENDCASE
			ENDIF
		ENDIF

		RETURN
	ENDPROC


	************************************************************************************************
	PROCEDURE get_ValueFromNullTerminatedValue
		LPARAMETERS tcNullTerminatedValue
		LOCAL lcValue, lnNullPos
		lnNullPos	= AT(CHR(0), tcNullTerminatedValue )
		IF lnNullPos = 0
			lcValue		= CHRTRAN( tcNullTerminatedValue, ['], ["] )
		ELSE
			lcValue		= CHRTRAN( LEFT( tcNullTerminatedValue, lnNullPos - 1 ), ['], ["] )
		ENDIF
		RETURN lcValue
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toModulo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineaExcluida
		LPARAMETERS tn_Linea, tnBloquesExclusion, taBloquesExclusion

		EXTERNAL ARRAY taBloquesExclusion
		LOCAL X, llExcluida

		FOR X = 1 TO tnBloquesExclusion
			IF BETWEEN( tn_Linea, taBloquesExclusion(X,1), taBloquesExclusion(X,2) )
				llExcluida	= .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN llExcluida
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineIsOnlyCommentAndNoMetadata
		LPARAMETERS tcLine, tcComment
		LOCAL lllineIsOnlyCommentAndNoMetadata, ln_AT_Cmt

		THIS.get_SeparatedLineAndComment( @tcLine, @tcComment )

		DO CASE
		CASE LEFT(tcLine,2) == '*<'
			tcComment	= tcLine

		CASE EMPTY(tcLine) OR LEFT(tcLine, 1) == '*' OR LEFT(tcLine + ' ', 5) == 'NOTE ' && Vac�a o Comentarios
			lllineIsOnlyCommentAndNoMetadata = .T.

		ENDCASE

		RETURN lllineIsOnlyCommentAndNoMetadata
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarAsignacion
		LPARAMETERS tcAsignacion, tcComentario
		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada, lnPos
		THIS.get_SeparatedPropAndValue( @tcAsignacion, @lcPropName, @lcValor )
		tcComentario	= ''
		THIS.normalizarValorPropiedad( @lcPropName, @lcValor, @tcComentario )
		tcAsignacion	= lcPropName + ' = ' + lcValor
		RETURN tcAsignacion
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarValorPropiedad
		LPARAMETERS tcProp, tcValue, tcComentario
		LOCAL lcValue, I
		tcComentario	= ''

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE tcProp == '_memberdata'
			lcValue	= ''

			FOR I = 1 TO OCCURS( '/>', tcValue )
				TEXT TO lcValue TEXTMERGE ADDITIVE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>		<<STREXTRACT( tcValue, '<memberdata ', '/>', I, 1+4 )>>
				ENDTEXT
			ENDFOR

			TEXT TO tcValue TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<VFPData>
				<<SUBSTR( lcValue, 3)>>
				<<>>		</VFPData>
			ENDTEXT

		CASE LEFT( tcValue, C_LEN_FB2P_VALUE_I ) == C_FB2P_VALUE_I
			*-- Valor especial Fox con cabecera CHR(1): Debo quitarla y normalizar el valor
			tcValue	= C_FB2P_VALUE_I ;
				+ STRTRAN( STRTRAN( STRTRAN( STRTRAN( ;
				STREXTRACT( tcValue, C_FB2P_VALUE_I, C_FB2P_VALUE_F, 1, 1 ) ;
				, CR_LF, '&#13+10;' ), C_CR, '&#13;' ), C_LF, '&#10;' ), '&#13+10;', CR_LF ) ;
				+ C_FB2P_VALUE_F


		ENDCASE

		RETURN tcValue
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarValorXML
		LPARAMETERS tcValor
		*-- NORMALIZA EL TEXTO INDICADO, COMPRIMIENDO LOS S�MBOLOS XML ESPECIALES.
		tcValor = STRTRAN(tcValor, CHR(38), CHR(38) + 'amp;')	&& reemplaza &  por  &amp;		&&
		tcValor = STRTRAN(tcValor, CHR(39), CHR(38) + 'apos;')	&& reemplaza '  por  &apos;		&&
		tcValor = STRTRAN(tcValor, CHR(34), CHR(38) + 'quot;')	&& reemplaza "  por  &quot;		&&
		tcValor = STRTRAN(tcValor, '<', CHR(38) + 'lt;') 		&&  reemplaza <  por  &lt;		&&
		tcValor = STRTRAN(tcValor, '>', CHR(38) + 'gt;')		&&  reemplaza >  por  &gt;		&&
		tcValor = STRTRAN(tcValor, CHR(13)+CHR(10), CHR(10))	&& reeemplaza CR+LF por LF
		tcValor = CHRTRAN(tcValor, CHR(13), CHR(10))			&& reemplaza CR por LF

		RETURN tcValor
	ENDPROC


	*******************************************************************************************************************
	FUNCTION RowTimeStamp(ltDateTime)
		* Generate a FoxPro 3.0-style row timestamp
		*-- CONVIERTE UN DATO TIPO DATETIME EN TIMESTAMP NUMERICO USADO POR LOS ARCHIVOS SCX/VCX/etc.
		LOCAL lcTimeValue, tnTimeStamp

		TRY
			IF EMPTY(ltDateTime)
				tnTimeStamp = 0
				EXIT
			ENDIF

			IF VARTYPE(m.ltDateTime) <> 'T'
				m.ltDateTime		= DATETIME()
			ENDIF

			tnTimeStamp = ( YEAR(m.ltDateTime) - 1980) * 2^25 ;
				+ MONTH(m.ltDateTime) * 2^21 ;
				+ DAY(m.ltDateTime) * 2^16 ;
				+ HOUR(m.ltDateTime) * 2^11 ;
				+ MINUTE(m.ltDateTime) * 2^5 ;
				+ SEC(m.ltDateTime)
		ENDTRY

		RETURN INT(tnTimeStamp)
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE sortPropsAndValues_SetAndGetSCXPropNames
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcOperation				(!v IN    ) Operaci�n a realizar ("SETNAME" o "GETNAME")
		* tcPropName				(!v IN    ) Nombre de la propiedad
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcOperation, tcPropName
		LOCAL lcPropName, lnPropType
		lcPropName	= tcPropName
		tcOperation	= UPPER(EVL(tcOperation,''))
		lnPropType	= 0		&& System property

		DO CASE
		CASE tcOperation == 'GETNAME'
			lcPropName	= SUBSTR(tcPropName,5)
		CASE NOT tcOperation == 'SETNAME'
			ERROR C_ONLY_SETNAME_AND_GETNAME_RECOGNIZED_LOC
		CASE lcPropName == 'ButtonCount'
			lcPropName	= 'A005' + lcPropName
		CASE lcPropName == 'ColumnCount'
			lcPropName	= 'A010' + lcPropName
		CASE lcPropName == 'Value'
			lcPropName	= 'A015' + lcPropName
		CASE lcPropName == 'Comment'
			lcPropName	= 'A020' + lcPropName
		CASE lcPropName == 'ControlSource'
			lcPropName	= 'A025' + lcPropName
		CASE lcPropName == 'DataSession'
			lcPropName	= 'A030' + lcPropName
		CASE lcPropName == 'DeleteMark'
			lcPropName	= 'A035' + lcPropName
		CASE lcPropName == 'ScaleMode'
			lcPropName	= 'A040' + lcPropName
		CASE lcPropName == 'Tag'
			lcPropName	= 'A045' + lcPropName
		CASE lcPropName == 'Top'
			lcPropName	= 'A050' + lcPropName
		CASE lcPropName == 'Left'
			lcPropName	= 'A055' + lcPropName
		CASE lcPropName == 'Height'
			lcPropName	= 'A060' + lcPropName
		CASE lcPropName == 'Width'
			lcPropName	= 'A065' + lcPropName
		CASE lcPropName == 'MaxLength'
			lcPropName	= 'A070' + lcPropName
		CASE lcPropName == 'Alias'
			lcPropName	= 'A075' + lcPropName
		CASE lcPropName == 'BufferModeOverride'
			lcPropName	= 'A080' + lcPropName
		CASE lcPropName == 'Order'
			lcPropName	= 'A085' + lcPropName
		CASE lcPropName == 'OrderDirection'
			lcPropName	= 'A090' + lcPropName
		CASE lcPropName == 'CursorSource'
			lcPropName	= 'A095' + lcPropName
		CASE lcPropName == 'Exclusive'
			lcPropName	= 'A100' + lcPropName
		CASE lcPropName == 'Filter'
			lcPropName	= 'A105' + lcPropName
		CASE lcPropName == 'Panel'
			lcPropName	= 'A110' + lcPropName
		CASE lcPropName == 'ReadOnly'
			lcPropName	= 'A115' + lcPropName
		CASE lcPropName == 'RecordSource'
			lcPropName	= 'A120' + lcPropName
		CASE lcPropName == 'RecordSourceType'
			lcPropName	= 'A125' + lcPropName
		CASE lcPropName == 'NoDataOnLoad'
			lcPropName	= 'A130' + lcPropName
		CASE lcPropName == 'OpenViews'
			lcPropName	= 'A135' + lcPropName
		CASE lcPropName == 'AutoOpenTables'
			lcPropName	= 'A140' + lcPropName
		CASE lcPropName == 'AutoCloseTables'
			lcPropName	= 'A145' + lcPropName
		CASE lcPropName == 'InitialSelectedAlias'
			lcPropName	= 'A150' + lcPropName
		CASE lcPropName == 'DataSource'
			lcPropName	= 'A155' + lcPropName
		CASE lcPropName == 'DataSourceType '
			lcPropName	= 'A160' + lcPropName
		CASE lcPropName == 'Desktop'
			lcPropName	= 'A165' + lcPropName
		CASE lcPropName == 'ShowWindow'
			lcPropName	= 'A170' + lcPropName
		CASE lcPropName == 'ScrollBars'
			lcPropName	= 'A175' + lcPropName
		CASE lcPropName == 'ShowInTaskBar'
			lcPropName	= 'A180' + lcPropName
		CASE lcPropName == 'DoCreate'
			lcPropName	= 'A185' + lcPropName
		CASE lcPropName == 'Tag'
			lcPropName	= 'A190' + lcPropName
		CASE lcPropName == 'OLEDragMode'
			lcPropName	= 'A195' + lcPropName
		CASE lcPropName == 'OLEDragPicture'
			lcPropName	= 'A200' + lcPropName
		CASE lcPropName == 'OLEDropMode'
			lcPropName	= 'A205' + lcPropName
		CASE lcPropName == 'OLEDropEffects'
			lcPropName	= 'A210' + lcPropName
		CASE lcPropName == 'ShowTips'
			lcPropName	= 'A215' + lcPropName
		CASE lcPropName == 'BufferMode'
			lcPropName	= 'A220' + lcPropName
		CASE lcPropName == 'AutoCenter'
			lcPropName	= 'A225' + lcPropName
		CASE lcPropName == 'AutoSize'
			lcPropName	= 'A230' + lcPropName
		CASE lcPropName == 'WordWrap'
			lcPropName	= 'A235' + lcPropName
		CASE lcPropName == 'Picture'
			lcPropName	= 'A240' + lcPropName
		CASE lcPropName == 'BackStyle'
			lcPropName	= 'A245' + lcPropName
		CASE lcPropName == 'BorderStyle'
			lcPropName	= 'A250' + lcPropName
		CASE lcPropName == 'BorderWidth'
			lcPropName	= 'A255' + lcPropName
		CASE lcPropName == 'Caption'
			lcPropName	= 'A260' + lcPropName
		CASE lcPropName == 'ControlBox'
			lcPropName	= 'A265' + lcPropName
		CASE lcPropName == 'Closable'
			lcPropName	= 'A270' + lcPropName
		CASE lcPropName == 'Curvature'
			lcPropName	= 'A275' + lcPropName
		CASE lcPropName == 'FontBold'
			lcPropName	= 'A280' + lcPropName
		CASE lcPropName == 'FontCondense'
			lcPropName	= 'A285' + lcPropName
		CASE lcPropName == 'FontExtend'
			lcPropName	= 'A290' + lcPropName
		CASE lcPropName == 'FontItalic'
			lcPropName	= 'A295' + lcPropName
		CASE lcPropName == 'FontName'
			lcPropName	= 'A300' + lcPropName
		CASE lcPropName == 'FontOutline'
			lcPropName	= 'A305' + lcPropName
		CASE lcPropName == 'FontShadow'
			lcPropName	= 'A310' + lcPropName
		CASE lcPropName == 'FontSize'
			lcPropName	= 'A315' + lcPropName
		CASE lcPropName == 'FontStrikethru'
			lcPropName	= 'A320' + lcPropName
		CASE lcPropName == 'FontUnderline'
			lcPropName	= 'A325' + lcPropName
		CASE lcPropName == 'HalfHeightCaption'
			lcPropName	= 'A330' + lcPropName
		CASE lcPropName == 'Margin'
			lcPropName	= 'A335' + lcPropName
		CASE lcPropName == 'MaxButton'
			lcPropName	= 'A340' + lcPropName
		CASE lcPropName == 'MinButton'
			lcPropName	= 'A345' + lcPropName
		CASE lcPropName == 'Movable'
			lcPropName	= 'A350' + lcPropName
		CASE lcPropName == 'MaxHeight'
			lcPropName	= 'A355' + lcPropName
		CASE lcPropName == 'MaxWidth'
			lcPropName	= 'A360' + lcPropName
		CASE lcPropName == 'MinHeight'
			lcPropName	= 'A365' + lcPropName
		CASE lcPropName == 'MinWidth'
			lcPropName	= 'A370' + lcPropName
		CASE lcPropName == 'MaxTop'
			lcPropName	= 'A375' + lcPropName
		CASE lcPropName == 'MaxLeft'
			lcPropName	= 'A380' + lcPropName
		CASE lcPropName == 'MDIForm'
			lcPropName	= 'A385' + lcPropName
		CASE lcPropName == 'MousePointer'
			lcPropName	= 'A390' + lcPropName
		CASE lcPropName == 'MouseIcon'
			lcPropName	= 'A395' + lcPropName
		CASE lcPropName == 'Visible'
			lcPropName	= 'A400' + lcPropName
		CASE lcPropName == 'ClipControls'
			lcPropName	= 'A405' + lcPropName
		CASE lcPropName == 'DrawMode'
			lcPropName	= 'A410' + lcPropName
		CASE lcPropName == 'DrawStyle'
			lcPropName	= 'A415' + lcPropName
		CASE lcPropName == 'DrawWidth'
			lcPropName	= 'A420' + lcPropName
		CASE lcPropName == 'FillStyle'
			lcPropName	= 'A425' + lcPropName
		CASE lcPropName == 'Enabled'
			lcPropName	= 'A430' + lcPropName
		CASE lcPropName == 'Icon'
			lcPropName	= 'A435' + lcPropName
		CASE lcPropName == 'KeyPreview'
			lcPropName	= 'A440' + lcPropName
		CASE lcPropName == 'TabIndex'
			lcPropName	= 'A445' + lcPropName
		CASE lcPropName == 'TabStop'
			lcPropName	= 'A450' + lcPropName
		CASE lcPropName == 'TitleBar'
			lcPropName	= 'A455' + lcPropName
		CASE lcPropName == 'WindowType'
			lcPropName	= 'A460' + lcPropName
		CASE lcPropName == 'WindowState'
			lcPropName	= 'A465' + lcPropName
		CASE lcPropName == 'LockScreen'
			lcPropName	= 'A470' + lcPropName
		CASE lcPropName == 'AlwaysOnTop'
			lcPropName	= 'A475' + lcPropName
		CASE lcPropName == 'AlwaysOnBottom'
			lcPropName	= 'A480' + lcPropName
		CASE lcPropName == 'SizeBox'
			lcPropName	= 'A485' + lcPropName
		CASE lcPropName == 'SpecialEffect'
			lcPropName	= 'A490' + lcPropName
		CASE lcPropName == 'ZoomBox'
			lcPropName	= 'A495' + lcPropName
		CASE lcPropName == 'ZOrderSet'
			lcPropName	= 'A500' + lcPropName
		CASE lcPropName == 'HelpContextID'
			lcPropName	= 'A505' + lcPropName
		CASE lcPropName == 'WhatsThisHelpID'
			lcPropName	= 'A510' + lcPropName
		CASE lcPropName == 'WhatsThisHelp'
			lcPropName	= 'A515' + lcPropName
		CASE lcPropName == 'WhatsThisButton'
			lcPropName	= 'A520' + lcPropName
		CASE lcPropName == 'RightToLeft'
			lcPropName	= 'A525' + lcPropName
		CASE lcPropName == 'DefOleLCID'
			lcPropName	= 'A530' + lcPropName
		CASE lcPropName == 'MacDesktop'
			lcPropName	= 'A535' + lcPropName
		CASE lcPropName == 'ColorSource'
			lcPropName	= 'A540' + lcPropName
		CASE lcPropName == 'ForeColor'
			lcPropName	= 'A545' + lcPropName
		CASE lcPropName == 'DisableForeColor'
			lcPropName	= 'A550' + lcPropName
		CASE lcPropName == 'BackColor'
			lcPropName	= 'A555' + lcPropName
		CASE lcPropName == 'FillColor'
			lcPropName	= 'A560' + lcPropName
		CASE lcPropName == 'HScrollSmallChange'
			lcPropName	= 'A565' + lcPropName
		CASE lcPropName == 'VScrollSmallChange'
			lcPropName	= 'A570' + lcPropName
		CASE lcPropName == 'ContinuousScroll'
			lcPropName	= 'A575' + lcPropName
		CASE lcPropName == 'Themes'
			lcPropName	= 'A580' + lcPropName
		CASE lcPropName == 'BindControls'
			lcPropName	= 'A585' + lcPropName
		CASE lcPropName == 'AllowOutput'
			lcPropName	= 'A590' + lcPropName
		CASE lcPropName == 'Dockable'
			lcPropName	= 'A595' + lcPropName
		CASE lcPropName == '_memberdata'
			lcPropName	= 'A995' + lcPropName
		CASE lcPropName == 'Name'
			lnPropType	= 1		&& System "Name" property
			lcPropName	= 'A999' + lcPropName
		OTHERWISE
			lnPropType	= 2		&& User property
			lcPropName	= 'A998' + lcPropName
		ENDCASE

		RETURN lcPropName
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE sortPropsAndValues
		* KNOWLEDGE BASE:
		* 02/12/2013	FDBOZZO		Fidel Charny me pas� un ejemplo donde se pierden propiedades f�sicamente
		*							si se ordenan alfab�ticamente en un ADD OBJECT. Pierde "picture" y otras m�s.
		*							Pareciera que la �ltima debe ser "Name".
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taPropsAndValues			(!@ IN    ) El array con las propiedades y valores del objeto o clase
		* tnPropsAndValues_Count	(!v IN    ) Cantidad de propiedades
		* tnSortType				(!v IN    ) Tipo de sort:
		*											0=Solo separar propiedades de clase y de objetos (.)
		*											1=Sort completo de propiedades (para la versi�n TEXTO)
		*											2=Sort completo de propiedades con "Name" al final (para la versi�n BIN)
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taPropsAndValues, tnPropsAndValues_Count, tnSortType
		EXTERNAL ARRAY taPropsAndValues

		TRY
			LOCAL I, X, lnArrayCols, laPropsAndValues(1,2), lcPropName, lcSortedMemo, lcMethods
			lnArrayCols	= ALEN( taPropsAndValues, 2 )
			DIMENSION laPropsAndValues( tnPropsAndValues_Count, lnArrayCols )
			ACOPY( taPropsAndValues, laPropsAndValues )

			WITH THIS AS c_conversor_base OF 'FOXBIN2PRG.PRG'
				IF m.tnSortType >= 1
					* CON SORT:
					* - A las que no tienen '.' les pongo 'A' por delante, y al resto 'B' por delante para que queden al final
					FOR I = 1 TO m.tnPropsAndValues_Count
						IF '.' $ laPropsAndValues(I,1)
							IF m.tnSortType = 2
								laPropsAndValues(I,1)	= 'B' + JUSTSTEM(laPropsAndValues(I,1)) + '.' ;
									+ .sortPropsAndValues_SetAndGetSCXPropNames( 'SETNAME', JUSTEXT(laPropsAndValues(I,1)) )
							ELSE
								laPropsAndValues(I,1)	= 'B' + laPropsAndValues(I,1)
							ENDIF
						ELSE
							IF m.tnSortType = 2
								laPropsAndValues(I,1)	= .sortPropsAndValues_SetAndGetSCXPropNames( 'SETNAME', laPropsAndValues(I,1) )
							ELSE
								laPropsAndValues(I,1)	= 'A' + laPropsAndValues(I,1)
							ENDIF
						ENDIF
					ENDFOR

					IF .l_PropSort_Enabled
						ASORT( laPropsAndValues, 1, -1, 0, 1)
					ENDIF


					FOR I = 1 TO m.tnPropsAndValues_Count
						*-- Quitar caracteres agregados antes del SORT
						IF '.' $ laPropsAndValues(I,1)
							IF m.tnSortType = 2
								taPropsAndValues(I,1)	= JUSTSTEM( SUBSTR( laPropsAndValues(I,1), 2 ) ) + '.' ;
									+ .sortPropsAndValues_SetAndGetSCXPropNames( 'GETNAME', JUSTEXT(laPropsAndValues(I,1)) )
							ELSE
								taPropsAndValues(I,1)	= SUBSTR( laPropsAndValues(I,1), 2 )
							ENDIF
						ELSE
							IF m.tnSortType = 2
								taPropsAndValues(I,1)	= .sortPropsAndValues_SetAndGetSCXPropNames( 'GETNAME', laPropsAndValues(I,1) )
							ELSE
								taPropsAndValues(I,1)	= SUBSTR( laPropsAndValues(I,1), 2 )
							ENDIF
						ENDIF

						taPropsAndValues(I,2)	= laPropsAndValues(I,2)

						IF lnArrayCols >= 3
							taPropsAndValues(I,3)	= laPropsAndValues(I,3)
						ENDIF
					ENDFOR

				ELSE	&& m.tnSortType = 0
					*-- SIN SORT: Creo 2 arrays, el bueno y el temporal, y al terminar agrego el temporal al bueno.
					*-- Debo separar las props.normales de las de los objetos (ocurre cuando es un ADD OBJECT)
					X	= 0

					*-- PRIMERO las que no tienen punto
					FOR I = 1 TO m.tnPropsAndValues_Count
						IF EMPTY( laPropsAndValues(I,1) )
							LOOP
						ENDIF

						IF NOT '.' $ laPropsAndValues(I,1)
							X	= X + 1
							taPropsAndValues(X,1)	= laPropsAndValues(I,1)
							taPropsAndValues(X,2)	= laPropsAndValues(I,2)
							IF lnArrayCols >= 3
								taPropsAndValues(X,3)	= laPropsAndValues(I,3)
							ENDIF
						ENDIF
					ENDFOR

					*-- LUEGO las dem�s props.
					FOR I = 1 TO m.tnPropsAndValues_Count
						IF EMPTY( laPropsAndValues(I,1) )
							LOOP
						ENDIF

						IF '.' $ laPropsAndValues(I,1)
							X	= X + 1
							taPropsAndValues(X,1)	= laPropsAndValues(I,1)
							taPropsAndValues(X,2)	= laPropsAndValues(I,2)
							IF lnArrayCols >= 3
								taPropsAndValues(X,3)	= laPropsAndValues(I,3)
							ENDIF
						ENDIF
					ENDFOR
				ENDIF
			ENDWITH	&& THIS AS C_CONVERSOR_BASE OF 'FOXBIN2PRG.PRG'


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE writeLog
		LPARAMETERS tcText

		TRY
			THIS.c_TextLog	= THIS.c_TextLog + TTOC(DATETIME(),3) + '  ' + EVL(tcText,'') + CR_LF
		CATCH
		ENDTRY
	ENDPROC


ENDDEFINE



*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_bin AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_bin OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_add_object" display="analizarBloque_ADD_OBJECT"/>] ;
		+ [<memberdata name="analizarbloque_defined_pam" display="analizarBloque_DEFINED_PAM"/>] ;
		+ [<memberdata name="analizarbloque_define_class" display="analizarBloque_DEFINE_CLASS"/>] ;
		+ [<memberdata name="analizarbloque_enddefine" display="analizarBloque_ENDDEFINE"/>] ;
		+ [<memberdata name="analizarbloque_foxbin2prg" display="analizarBloque_FoxBin2Prg"/>] ;
		+ [<memberdata name="analizarbloque_hidden" display="analizarBloque_HIDDEN"/>] ;
		+ [<memberdata name="analizarbloque_include" display="analizarBloque_INCLUDE"/>] ;
		+ [<memberdata name="analizarbloque_metadata" display="analizarBloque_METADATA"/>] ;
		+ [<memberdata name="analizarbloque_ole_def" display="analizarBloque_OLE_DEF"/>] ;
		+ [<memberdata name="analizarbloque_procedure" display="analizarBloque_PROCEDURE"/>] ;
		+ [<memberdata name="analizarbloque_protected" display="analizarBloque_PROTECTED"/>] ;
		+ [<memberdata name="analizarlineasdeprocedure" display="analizarLineasDeProcedure"/>] ;
		+ [<memberdata name="classmethods2memo" display="classMethods2Memo"/>] ;
		+ [<memberdata name="classprops2memo" display="classProps2Memo"/>] ;
		+ [<memberdata name="createclasslib" display="createClasslib"/>] ;
		+ [<memberdata name="createclasslib_recordheader" display="createClasslib_RecordHeader"/>] ;
		+ [<memberdata name="createform" display="createForm"/>] ;
		+ [<memberdata name="createform_recordheader" display="createForm_RecordHeader"/>] ;
		+ [<memberdata name="createproject" display="createProject"/>] ;
		+ [<memberdata name="createproject_recordheader" display="createProject_RecordHeader"/>] ;
		+ [<memberdata name="createreport" display="createReport"/>] ;
		+ [<memberdata name="createmenu" display="createMenu"/>] ;
		+ [<memberdata name="defined_pam2memo" display="defined_PAM2Memo"/>] ;
		+ [<memberdata name="emptyrecord" display="emptyRecord"/>] ;
		+ [<memberdata name="escribirarchivobin" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="evaluate_pam" display="Evaluate_PAM"/>] ;
		+ [<memberdata name="evaluardefiniciondeprocedure" display="evaluarDefinicionDeProcedure"/>] ;
		+ [<memberdata name="getclassmethodcomment" display="getClassMethodComment"/>] ;
		+ [<memberdata name="getclasspropertycomment" display="getClassPropertyComment"/>] ;
		+ [<memberdata name="get_listnameswithvaluesfrom_inline_metadatatag" display="get_ListNamesWithValuesFrom_InLine_MetadataTag"/>] ;
		+ [<memberdata name="get_valuebyname_fromlistnameswithvalues" display="get_ValueByName_FromListNamesWithValues"/>] ;
		+ [<memberdata name="hiddenandprotected_pam" display="hiddenAndProtected_PAM"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="insert_allobjects" display="insert_AllObjects"/>] ;
		+ [<memberdata name="insert_object" display="insert_Object"/>] ;
		+ [<memberdata name="objectmethods2memo" display="objectMethods2Memo"/>] ;
		+ [<memberdata name="set_line" display="set_Line"/>] ;
		+ [<memberdata name="strip_dimensions" display="strip_Dimensions"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase correspondiente con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )
	ENDPROC


	*******************************************************************************************************************
	FUNCTION get_ValueByName_FromListNamesWithValues
		*-- ASIGNO EL VALOR DEL ARRAY DE DATOS Y VALORES PARA LA PROPIEDAD INDICADA
		LPARAMETERS tcPropName, tcValueType, taPropsAndValues
		LOCAL lnPos, luPropValue

		lnPos	= ASCAN( taPropsAndValues, tcPropName, 1, 0, 1, 1+2+4+8)

		IF lnPos = 0 OR EMPTY( taPropsAndValues( lnPos, 2 ) )
			*-- Valores no encontrados o vac�os
			luPropValue	= ''
		ELSE
			luPropValue	= taPropsAndValues( lnPos, 2 )
		ENDIF

		DO CASE
		CASE tcValueType = 'I'
			luPropValue	= CAST( luPropValue AS INTEGER )

		CASE tcValueType = 'N'
			luPropValue	= CAST( luPropValue AS DOUBLE )

		CASE tcValueType = 'T'
			luPropValue	= CAST( luPropValue AS DATETIME )

		CASE tcValueType = 'D'
			luPropValue	= CAST( luPropValue AS DATE )

		CASE tcValueType = 'E'
			luPropValue	= EVALUATE( luPropValue )

		OTHERWISE && Asumo 'C' para lo dem�s
			luPropValue	= luPropValue

		ENDCASE

		RETURN luPropValue
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE get_ListNamesWithValuesFrom_InLine_MetadataTag
		*-- OBTENGO EL ARRAY DE DATOS Y VALORES DE LA LINEA DE METADATOS INDICADA
		*-- NOTA: Los valores NO PUEDEN contener comillas dobles en su valor, ya que generar�a un error al parsearlos.
		*-- Ejemplo:
		*< FileMetadata: Type="V" Cpid="1252" Timestamp="1131901580" ID="1129207528" ObjRev="544" />
		*< OLE: Nombre="frm_form.Pageframe1.Page1.Cnt_controles_h.Olecontrol1" Parent="frm_form.Pageframe1.Page1.Cnt_controles_h" ObjName="Olecontrol1" Checksum="1685567300" Value="0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPg...ADAP7AAAA==" />
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLineWithMetadata		(@! IN    ) L�nea con metadatos y un tag de metadatos
		* taPropsAndValues			(@!    OUT) Array a devolver con las propiedades y valores encontrados
		* tnPropsAndValues_Count	(@!    OUT) Cantidad de propiedades encontradas
		* tcLeftTag					(v! IN    ) TAG de inicio de los metadatos
		* tcRightTag				(v! IN    ) TAG de fin de los metadatos
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcLineWithMetadata, taPropsAndValues, tnPropsAndValues_Count, tcLeftTag, tcRightTag
		EXTERNAL ARRAY taPropsAndValues

		LOCAL lcMetadatos, I, X, lnEqualSigns, lcNextVar, lcStr, lcVirtualMeta, lnPos1, lnPos2, lnLastPos, lnCantComillas
		STORE '' TO lcVirtualMeta
		STORE 0 TO lnPos1, lnPos2, lnLastPos, tnPropsAndValues_Count, I, X

		lcMetadatos		= ALLTRIM( STREXTRACT( tcLineWithMetadata, tcLeftTag, tcRightTag, 1, 1) )
		lnCantComillas	= OCCURS( '"', lcMetadatos )

		IF lnCantComillas % 2 <> 0	&& Valido que las comillas "" sean pares
			ERROR "Error de datos: No se puede parsear porque las comillas no son pares en la l�nea [" + lcMetadatos + "]"
		ENDIF

		lnLastPos	= 1
		DIMENSION taPropsAndValues( lnCantComillas / 2, 2 )

		*-------------------------------------------------------------------------------------
		* IMPORTANTE!!
		* ------------
		* SI SE SEPARAN LAS IGUALDADES CON ESPACIOS, �STAS DEJAN DE RECONOCERSE!!  (prop = "valor" en vez de prop="valor")
		* TENER EN CUENTA AL GENERAR EL TEXTO O AL MODIFICARLO MANUALMENTE AL MERGEAR
		*-------------------------------------------------------------------------------------
		FOR I = 1 TO lnCantComillas STEP 2
			X	= X + 1

			*  Type="V" Cpid="1252"
			*       ^ ^					=> Posiciones del par de comillas dobles
			lnPos1	= AT( '"', lcMetadatos, I )
			lnPos2	= AT( '"', lcMetadatos, I + 1 )

			*  Type="V" Cpid="1252"
			*          ^     ^    ^			=> LastPos, lnPos1 y lnPos2
			taPropsAndValues(X,1)	= ALLTRIM( GETWORDNUM( SUBSTR( lcMetadatos, lnLastPos, lnPos1 - lnLastPos ), 1, '=' ) )
			taPropsAndValues(X,2)	= SUBSTR( lcMetadatos, lnPos1 + 1, lnPos2 - lnPos1 - 1 )

			lnLastPos = lnPos2 + 1
		ENDFOR

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeExclusion
		LPARAMETERS taCodeLines, tnCodeLines, ta_ID_Bloques, taBloquesExclusion, tnBloquesExclusion
		* LOS BLOQUES DE EXCLUSI�N SON AQUELLOS QUE TIENEN TEXT/ENDTEXT OF #IF .F./#ENDIF Y SE USAN PARA NO BUSCAR
		* INSTRUCCIONES COMO "DEFINE CLASS" O "PROCEDURE" EN LOS MISMOS.
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo de texto donde buscar
		* tnCodeLines				(?@ IN    ) Cantidad de l�neas de c�digo
		* ta_ID_Bloques				(?@ IN    ) Array de pares de identificadores (2 cols). Ej: '#IF .F.','#ENDI' ; 'TEXT','ENDTEXT' ; etc
		* taBloquesExclusion		(?@    OUT) Array con las posiciones de los bloques (2 cols). Ej: 3,14 ; 23,58 ; etc
		* tnBloquesExclusion		(?@    OUT) Cantidad de bloques de exclusi�n
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY ta_ID_Bloques, taBloquesExclusion

		TRY
			LOCAL lnBloques, I, X, lnPrimerID, lnLen_IDFinBQ
			DIMENSION taBloquesExclusion(1,2)
			STORE 0 TO tnBloquesExclusion, lnPrimerID, I, X, lnLen_IDFinBQ

			IF tnCodeLines > 1
				IF EMPTY(ta_ID_Bloques)
					DIMENSION ta_ID_Bloques(2,2)
					ta_ID_Bloques(1,1)	= '#IF .F.'
					ta_ID_Bloques(1,2)	= '#ENDI'
					ta_ID_Bloques(2,1)	= C_TEXT
					ta_ID_Bloques(2,2)	= C_ENDTEXT
				ENDIF

				*-- B�squeda del ID de inicio de bloque
				FOR I = 1 TO tnCodeLines
					lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( taCodeLines(I), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

					IF THIS.lineIsOnlyCommentAndNoMetadata( @lcLine )
						LOOP
					ENDIF

					lnPrimerID	= ASCAN( ta_ID_Bloques, lcLine, 1, 0, 1, 1+8 )

					IF lnPrimerID > 0	&& Se ha identificado un ID de bloque excluyente
						tnBloquesExclusion		= tnBloquesExclusion + 1
						lnLen_IDFinBQ			= LEN( ta_ID_Bloques(lnPrimerID,2) )
						DIMENSION taBloquesExclusion(tnBloquesExclusion,2)
						taBloquesExclusion(tnBloquesExclusion,1)	= I

						* B�squeda del ID de fin de bloque
						FOR I = I + 1 TO tnCodeLines
							lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( taCodeLines(I), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

							IF THIS.lineIsOnlyCommentAndNoMetadata( @lcLine )
								LOOP
							ENDIF

							IF LEFT( lcLine, lnLen_IDFinBQ ) == ta_ID_Bloques(lnPrimerID,2)	&& Fin de bloque encontrado (#ENDI, ENDTEXT, etc)
								taBloquesExclusion(tnBloquesExclusion,2)	= I
								EXIT
							ENDIF
						ENDFOR

						*-- Validaci�n
						IF EMPTY(taBloquesExclusion(tnBloquesExclusion,2))
							ERROR 'No se ha encontrado el marcador de fin [' + ta_ID_Bloques(lnPrimerID,2) ;
								+ '] que cierra al marcador de inicio [' + ta_ID_Bloques(lnPrimerID,1) ;
								+ '] de la l�nea ' + TRANSFORM(taBloquesExclusion(tnBloquesExclusion,1))
						ENDIF
					ENDIF
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_FoxBin2Prg
		*------------------------------------------------------
		*-- Analiza el bloque <FOXBIN2PRG>
		*------------------------------------------------------
		LPARAMETERS toModulo, tcLine, taCodeLines, I, tnCodeLines

		LOCAL llBloqueEncontrado, laPropsAndValues(1,2), lnPropsAndValues_Count

		IF LEFT( tcLine + ' ', LEN(C_FB2PRG_META_I) + 1 ) == C_FB2PRG_META_I + ' '
			llBloqueEncontrado	= .T.

			*-- Metadatos del m�dulo
			THIS.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_FB2PRG_META_I, C_FB2PRG_META_F )
			toModulo._Version		= THIS.get_ValueByName_FromListNamesWithValues( 'Version', 'N', @laPropsAndValues )
			toModulo._SourceFile	= THIS.get_ValueByName_FromListNamesWithValues( 'SourceFile', 'C', @laPropsAndValues )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createProject

		CREATE TABLE (THIS.c_OutputFile) ;
			( NAME			M ;
			, TYPE			C(1) ;
			, ID			N(10) ;
			, TIMESTAMP		N(10) ;
			, OUTFILE		M ;
			, HOMEDIR		M ;
			, EXCLUDE		L ;
			, MAINPROG		L ;
			, SAVECODE		L ;
			, DEBUG			L ;
			, ENCRYPT		L ;
			, NOLOGO		L ;
			, CMNTSTYLE		N(1) ;
			, OBJREV		N(5) ;
			, DEVINFO		M ;
			, SYMBOLS		M ;
			, OBJECT		M ;
			, CKVAL			N(6) ;
			, CPID			N(5) ;
			, OSTYPE		C(4) ;
			, OSCREATOR		C(4) ;
			, COMMENTS		M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, SCCDATA		M ;
			, LOCAL			L ;
			, KEY			C(32) ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createProject_RecordHeader
		LPARAMETERS toProject

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		INSERT INTO TABLABIN ;
			( NAME ;
			, TYPE ;
			, TIMESTAMP ;
			, OUTFILE ;
			, HOMEDIR ;
			, SAVECODE ;
			, DEBUG ;
			, ENCRYPT ;
			, NOLOGO ;
			, CMNTSTYLE ;
			, OBJREV ;
			, DEVINFO ;
			, OBJECT ;
			, RESERVED1 ;
			, RESERVED2 ;
			, LOCAL ;
			, KEY ) ;
			VALUES ;
			( UPPER(EVL(THIS.c_OriginalFileName,THIS.c_OutputFile)) ;
			, 'H' ;
			, 0 ;
			, '<Source>' + CHR(0) ;
			, toProject._HomeDir + CHR(0) ;
			, toProject._SaveCode ;
			, toProject._Debug ;
			, toProject._Encrypted ;
			, toProject._NoLogo ;
			, toProject._CmntStyle ;
			, 260 ;
			, toProject.getRowDeviceInfo() ;
			, toProject._HomeDir + CHR(0) ;
			, UPPER(THIS.c_OutputFile) ;
			, toProject._ServerHead.getRowServerInfo() ;
			, .T. ;
			, UPPER( JUSTSTEM( THIS.c_OutputFile) ) )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createClasslib

		CREATE TABLE (THIS.c_OutputFile) ;
			( PLATFORM		C(8) ;
			, UNIQUEID		C(10) ;
			, TIMESTAMP		N(10) ;
			, CLASS			M ;
			, CLASSLOC		M ;
			, BASECLASS		M ;
			, OBJNAME		M ;
			, PARENT		M ;
			, PROPERTIES	M ;
			, PROTECTED		M ;
			, METHODS		M ;
			, OBJCODE		M NOCPTRANS ;
			, OLE			M ;
			, OLE2			M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, RESERVED3		M ;
			, RESERVED4		M ;
			, RESERVED5		M ;
			, RESERVED6		M ;
			, RESERVED7		M ;
			, RESERVED8		M ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createClasslib_RecordHeader

		INSERT INTO TABLABIN ;
			( PLATFORM ;
			, UNIQUEID ;
			, RESERVED1 ) ;
			VALUES ;
			( 'COMMENT' ;
			, 'Class' ;
			, 'VERSION =   3.00' )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createForm

		CREATE TABLE (THIS.c_OutputFile) ;
			( PLATFORM		C(8) ;
			, UNIQUEID		C(10) ;
			, TIMESTAMP		N(10) ;
			, CLASS			M ;
			, CLASSLOC		M ;
			, BASECLASS		M ;
			, OBJNAME		M ;
			, PARENT		M ;
			, PROPERTIES	M ;
			, PROTECTED		M ;
			, METHODS		M ;
			, OBJCODE		M NOCPTRANS ;
			, OLE			M ;
			, OLE2			M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, RESERVED3		M ;
			, RESERVED4		M ;
			, RESERVED5		M ;
			, RESERVED6		M ;
			, RESERVED7		M ;
			, RESERVED8		M ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createForm_RecordHeader

		INSERT INTO TABLABIN ;
			( PLATFORM ;
			, UNIQUEID ;
			, RESERVED1 ) ;
			VALUES ;
			( 'COMMENT' ;
			, 'Screen' ;
			, 'VERSION =   3.00' )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createReport

		CREATE TABLE (THIS.c_OutputFile) ;
			( 'PLATFORM'	C(8) ;
			, 'UNIQUEID'	C(10) ;
			, 'TIMESTAMP'	N(10) ;
			, 'OBJTYPE'		N(2) ;
			, 'OBJCODE'		N(3) ;
			, 'NAME'		M ;
			, 'EXPR'		M ;
			, 'VPOS'		N(9,3) ;
			, 'HPOS'		N(9,3) ;
			, 'HEIGHT'		N(9,3) ;
			, 'WIDTH'		N(9,3) ;
			, 'STYLE'		M ;
			, 'PICTURE'		M ;
			, 'ORDER'		M NOCPTRANS ;
			, 'UNIQUE'		L ;
			, 'COMMENT'		M ;
			, 'ENVIRON'		L ;
			, 'BOXCHAR'		C(1) ;
			, 'FILLCHAR'	C(1) ;
			, 'TAG'			M ;
			, 'TAG2'		M NOCPTRANS ;
			, 'PENRED'		N(5) ;
			, 'PENGREEN'	N(5) ;
			, 'PENBLUE'		N(5) ;
			, 'FILLRED'		N(5) ;
			, 'FILLGREEN'	N(5) ;
			, 'FILLBLUE'	N(5) ;
			, 'PENSIZE'		N(5) ;
			, 'PENPAT'		N(5) ;
			, 'FILLPAT'		N(5) ;
			, 'FONTFACE'	M ;
			, 'FONTSTYLE'	N(3) ;
			, 'FONTSIZE'	N(3) ;
			, 'MODE'		N(3) ;
			, 'RULER'		N(1) ;
			, 'RULERLINES'	N(1) ;
			, 'GRID'		L ;
			, 'GRIDV'		N(2) ;
			, 'GRIDH'		N(2) ;
			, 'FLOAT'		L ;
			, 'STRETCH'		L ;
			, 'STRETCHTOP'	L ;
			, 'TOP'			L ;
			, 'BOTTOM'		L ;
			, 'SUPTYPE'		N(1) ;
			, 'SUPREST'		N(1) ;
			, 'NOREPEAT'	L ;
			, 'RESETRPT'	N(2) ;
			, 'PAGEBREAK'	L ;
			, 'COLBREAK'	L ;
			, 'RESETPAGE'	L ;
			, 'GENERAL'		N(3) ;
			, 'SPACING'		N(3) ;
			, 'DOUBLE'		L ;
			, 'SWAPHEADER'	L ;
			, 'SWAPFOOTER'	L ;
			, 'EJECTBEFOR'	L ;
			, 'EJECTAFTER'	L ;
			, 'PLAIN'		L ;
			, 'SUMMARY'		L ;
			, 'ADDALIAS'	L ;
			, 'OFFSET'		N(3) ;
			, 'TOPMARGIN'	N(3) ;
			, 'BOTMARGIN'	N(3) ;
			, 'TOTALTYPE'	N(2) ;
			, 'RESETTOTAL'	N(2) ;
			, 'RESOID'		N(3) ;
			, 'CURPOS'		L ;
			, 'SUPALWAYS'	L ;
			, 'SUPOVFLOW'	L ;
			, 'SUPRPCOL'	N(1) ;
			, 'SUPGROUP'	N(2) ;
			, 'SUPVALCHNG'	L ;
			, 'SUPEXPR'		M ;
			, 'USER'		M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createMenu

		CREATE TABLE (THIS.c_OutputFile) ;
			( 'OBJTYPE'		Numeric(2) ;
			, 'OBJCODE'		Numeric(2) ;
			, 'NAME'		MEMO ;
			, 'PROMPT'		MEMO ;
			, 'COMMAND'		MEMO ;
			, 'MESSAGE'		MEMO ;
			, 'PROCTYPE'	Numeric(1) ;
			, 'PROCEDURE'	MEMO ;
			, 'SETUPTYPE'	Numeric(1) ;
			, 'SETUP'		MEMO ;
			, 'CLEANTYPE'	Numeric(1) ;
			, 'CLEANUP'		MEMO ;
			, 'MARK'		CHARACTER(1) ;
			, 'KEYNAME'		MEMO ;
			, 'KEYLABEL'	MEMO ;
			, 'SKIPFOR'		MEMO ;
			, 'NAMECHANGE'	Logical ;
			, 'NUMITEMS'	Numeric(2) ;
			, 'LEVELNAME'	CHARACTER(10) ;
			, 'ITEMNUM'		CHARACTER(3) ;
			, 'COMMENT'		MEMORY(4) ;
			, 'LOCATION'	Numeric(2) ;
			, 'SCHEME'		Numeric(2) ;
			, 'SYSRES'		Numeric(1) ;
			, 'RESNAME'		MEMORY(4) )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE emptyRecord
		LOCAL loReg
		SCATTER MEMO BLANK NAME loReg
		RETURN loReg
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE classProps2Memo
		*-- ARMA EL MEMO DE PROPERTIES CON LAS PROPIEDADES Y SUS VALORES
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		*-- ESTRUCTURA A ANALIZAR: Propiedades normales, con CR codificado (<fb2p_value>) y con CR+LF (<fb2p_value>)
		#IF .F.
			HEIGHT =   2.73
			NAME = "c1"
			prop1 = .F.		&& Mi prop 1
			prop_especial_cr = <fb2p_value>Este es el valor 1&#10;Este el 2&#10;Y Este bajo Shift_Enter el 3</fb2p_value>
			prop_especial_crlf = <fb2p_value>
			Este es el valor 1
			Este el 2
			Y Este bajo Shift_Enter el 3
			</fb2p_value>
			WIDTH =  27.40
			_MEMBERDATA = <VFPData>
			<memberdata NAME="mimetodo" DISPLAY="miMetodo"/>
			<memberdata NAME="mimetodo2" DISPLAY="miMetodo2"/>
			</VFPData>		&& XML Metadata for customizable properties
		#ENDIF
		*-- Fin: ESTRUCTURA A ANALIZAR:

		TRY
			LOCAL lcDefinedPAM, lnPos, lnPos2, laProps(1,2), lcLine, lcPropName, lcValue, I, lcAsignacion, lcMemo ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count
			lcMemo	= ''

			IF toClase._Prop_Count > 0
				DIMENSION laPropsAndValues( toClase._Prop_Count, 3 )
				ACOPY( toClase._Props, laPropsAndValues )
				lnPropsAndValues_Count	= toClase._Prop_Count

				*-- REORDENO LAS PROPIEDADES
				THIS.sortPropsAndValues( @laPropsAndValues, lnPropsAndValues_Count, 2 )


				*-- ARMO EL MEMO A DEVOLVER
				FOR I = 1 TO lnPropsAndValues_Count
					lcMemo	= lcMemo + laPropsAndValues(I,1) + ' = ' + laPropsAndValues(I,2) + CR_LF
				ENDFOR

			ENDIF && laProps > 0

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE objectProps2Memo
		*-- ARMA EL MEMO DE PROPERTIES CON LAS PROPIEDADES Y SUS VALORES
		LPARAMETERS toObjeto, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, laPropsAndValues(1,2), lcPropName, lcValue
		lcMemo	= ''

		IF toObjeto._Prop_Count > 0
			DIMENSION laPropsAndValues( toObjeto._Prop_Count, 2 )
			ACOPY( toObjeto._Props, laPropsAndValues )


			*-- REORDENO LAS PROPIEDADES
			THIS.sortPropsAndValues( @laPropsAndValues, toObjeto._Prop_Count, 2 )


			*-- ARMO EL MEMO A DEVOLVER
			FOR I = 1 TO toObjeto._Prop_Count
				lcMemo	= lcMemo + laPropsAndValues(I,1) + ' = ' + laPropsAndValues(I,2) + CR_LF
			ENDFOR

		ENDIF

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE classMethods2Memo
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, X, lcNombreObjeto ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcMemo	= ''

		*-- Recorrer los m�todos
		FOR I = 1 TO toClase._Procedure_Count
			loProcedure	= NULL
			loProcedure	= toClase._Procedures(I)

			IF '.' $ loProcedure._Nombre
				*-- cboNombre.InteractiveChange ==> No debe acortarse por ser m�todo modificado de combobox heredado de la clase
				*-- cntDatos.txtEdad.Valid		==> Debe acortarse si cntDatos es un objeto existente
				lcNombreObjeto	= LEFT( loProcedure._Nombre, AT('.', loProcedure._Nombre) - 1 )

				IF THIS.buscarObjetoDelMetodoPorNombre( lcNombreObjeto, toClase ) = 0
					TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<C_PROCEDURE>> <<loProcedure._Nombre>>
					ENDTEXT
				ELSE
					TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<C_PROCEDURE>> <<SUBSTR( loProcedure._Nombre, AT('.', loProcedure._Nombre) + 1 )>>
					ENDTEXT
				ENDIF
			ELSE
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<C_PROCEDURE>> <<loProcedure._Nombre>>
				ENDTEXT
			ENDIF

			*-- Incluir las l�neas del m�todo
			FOR X = 1 TO loProcedure._ProcLine_Count
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<loProcedure._ProcLines(X)>>
				ENDTEXT
			ENDFOR

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_ENDPROC>>
				<<>>
			ENDTEXT
		ENDFOR

		loProcedure	= NULL
		RELEASE loProcedure
		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE objectMethods2Memo
		LPARAMETERS toObjeto, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, X, lcNombreObjeto ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcMemo	= ''

		*-- Recorrer los m�todos
		FOR I = 1 TO toObjeto._Procedure_Count
			loProcedure	= NULL
			loProcedure	= toObjeto._Procedures(I)

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_PROCEDURE>> <<loProcedure._Nombre>>
			ENDTEXT

			*-- Incluir las l�neas del m�todo
			FOR X = 1 TO loProcedure._ProcLine_Count
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<loProcedure._ProcLines(X)>>
				ENDTEXT
			ENDFOR

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_ENDPROC>>
				<<>>
			ENDTEXT
		ENDFOR

		loProcedure	= NULL
		RELEASE loProcedure
		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getClassPropertyComment
		*-- Devuelve el comentario (columna 2 del array toClase._Props) de la propiedad indicada,
		*-- busc�ndola en la columna 2 por su nombre.
		LPARAMETERS tcPropName AS STRING, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL I, lcComentario
		lcComentario	= ''

		FOR I = 1 TO toClase._Prop_Count
			IF RTRIM( GETWORDNUM( toClase._Props(I,1), 1, '=' ) ) == tcPropName
				lcComentario	= toClase._Props( I, 2 )
				EXIT
			ENDIF
		ENDFOR

		RETURN lcComentario
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getClassMethodComment
		LPARAMETERS tcMethodName AS STRING, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL I, lcComentario ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcComentario	= ''

		FOR I = 1 TO toClase._Procedure_Count
			loProcedure	= toClase._Procedures(I)

			IF loProcedure._Nombre == tcMethodName
				lcComentario	= loProcedure._Comentario
				EXIT
			ENDIF
		ENDFOR

		RETURN lcComentario
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getTextFrom_BIN_FileStructure
		TRY
			LOCAL lcStructure, lnSelect
			lnSelect	= SELECT()
			SELECT 0
			USE (THIS.c_InputFile) AGAIN SHARED ALIAS _TABLABIN
			COPY STRUCTURE EXTENDED TO ( FORCEPATH( '_FRX_STRUC.DBF', ADDBS( SYS(2023) ) ) )
			**** CONTINUAR SI ES NECESARIO - SIN USO POR AHORA

		CATCH TO loEx
			THROW

		FINALLY
			USE IN (SELECT("_TABLABIN"))
			SELECT (lnSelect)
		ENDTRY

		RETURN lcStructure
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE defined_PAM2Memo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toClase					(!@ IN    ) Objeto de la Clase
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS toClase
		RETURN toClase._Defined_PAM
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE strip_Dimensions
		LPARAMETERS tcSeparatedCommaVars
		LOCAL lnPos1, lnPos2, I

		FOR I = OCCURS( '[', tcSeparatedCommaVars ) TO 1 STEP -1
			lnPos1	= AT( '[', tcSeparatedCommaVars, I )
			lnPos2	= AT( ']', tcSeparatedCommaVars, I )
			tcSeparatedCommaVars	= STUFF( tcSeparatedCommaVars, lnPos1, lnPos2 - lnPos1 + 1, '' )
		ENDFOR
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE hiddenAndProtected_PAM
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, lcPAM, lcComentario
		lcMemo	= ''

		THIS.Evaluate_PAM( @lcMemo, toClase._ProtectedProps, 'property', 'protected' )
		THIS.Evaluate_PAM( @lcMemo, toClase._HiddenProps, 'property', 'hidden' )
		THIS.Evaluate_PAM( @lcMemo, toClase._ProtectedMethods, 'method', 'protected' )
		THIS.Evaluate_PAM( @lcMemo, toClase._HiddenMethods, 'method', 'hidden' )

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Evaluate_PAM
		LPARAMETERS tcMemo AS STRING, tcPAM AS STRING, tcPAM_Type AS STRING, tcPAM_Visibility AS STRING

		LOCAL lcPAM, I

		FOR I = 1 TO OCCURS( ',', tcPAM + ',' )
			lcPAM	= ALLTRIM( GETWORDNUM( tcPAM, I, ',' ) )

			IF NOT EMPTY(lcPAM)
				IF EVL(tcPAM_Visibility, 'normal') == 'hidden'
					lcPAM	= lcPAM + '^'
				ENDIF

				TEXT TO tcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<lcPAM>>
					<<>>
				ENDTEXT
			ENDIF
		ENDFOR
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_Object
		LPARAMETERS toClase, toObjeto

		IF NOT THIS.l_Test
			*-- Inserto el objeto
			INSERT INTO TABLABIN ;
				( PLATFORM ;
				, UNIQUEID ;
				, TIMESTAMP ;
				, CLASS ;
				, CLASSLOC ;
				, BASECLASS ;
				, OBJNAME ;
				, PARENT ;
				, PROPERTIES ;
				, PROTECTED ;
				, METHODS ;
				, OLE ;
				, OLE2 ;
				, RESERVED1 ;
				, RESERVED2 ;
				, RESERVED3 ;
				, RESERVED4 ;
				, RESERVED5 ;
				, RESERVED6 ;
				, RESERVED7 ;
				, RESERVED8 ;
				, USER) ;
				VALUES ;
				( 'WINDOWS' ;
				, toObjeto._UniqueID ;
				, toObjeto._TimeStamp ;
				, toObjeto._Class ;
				, toObjeto._ClassLib ;
				, toObjeto._BaseClass ;
				, toObjeto._ObjName ;
				, toObjeto._Parent ;
				, THIS.objectProps2Memo( toObjeto, toClase ) ;
				, '' ;
				, THIS.objectMethods2Memo( toObjeto, toClase ) ;
				, toObjeto._Ole ;
				, toObjeto._Ole2 ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, toObjeto._User )
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_AllObjects
		*-- Recorro primero los objetos con ZOrder definido, y luego los dem�s
		*-- NOTA: Como consecuencia de una integraci�n de c�digo, puede que se hayan agregado objetos nuevos (desconocidos),
		*--	      pero todo lo dem�s tiene un ZOrder definido, que es el n�mero de registro original * 100.
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL N, X, lcObjName, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

			IF toClase._AddObject_Count > 0
				N	= 0

				*-- Armo array con el orden Z de los objetos
				DIMENSION laObjNames( toClase._AddObject_Count, 2 )

				FOR X = 1 TO toClase._AddObject_Count
					loObjeto			= toClase._AddObjects( X )
					laObjNames( X, 1 )	= loObjeto._Nombre
					laObjNames( X, 2 )	= loObjeto._ZOrder
				ENDFOR

				ASORT( laObjNames, 2, -1, 0, 1 )


				*-- Escribo los objetos en el orden Z
				FOR X = 1 TO toClase._AddObject_Count
					lcObjName	= laObjNames( X, 1 )

					FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
						*-- Verifico que sea el objeto que corresponde
						IF loObjeto._WriteOrder = 0 AND loObjeto._Nombre == lcObjName
							N	= N + 1
							loObjeto._WriteOrder	= N
							THIS.insert_Object( toClase, loObjeto )
							EXIT
						ENDIF
					ENDFOR
				ENDFOR


				*-- Recorro los objetos Desconocidos
				FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
					IF loObjeto._WriteOrder = 0
						THIS.insert_Object( toClase, loObjeto )
					ENDIF
				ENDFOR

			ENDIF	&& toClase._AddObject_Count > 0

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE set_Line
		LPARAMETERS tcLine, taCodeLines, I
		tcLine 	= LTRIM( taCodeLines(I), 0, ' ', CHR(9) )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarLineasDeProcedure
		LPARAMETERS toClase, toObjeto, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto, tc_Comentario ;
			, taBloquesExclusion, tnBloquesExclusion
		EXTERNAL ARRAY taCodeLines

		#IF .F.
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llEsProcedureDeClase, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'

			IF '.' $ tcProcedureAbierto AND VARTYPE(toObjeto) = 'O' AND toObjeto._Procedure_Count > 0
				loProcedure	= toObjeto._Procedures(toObjeto._Procedure_Count)
			ELSE
				llEsProcedureDeClase	= .T.
				loProcedure	= toClase._Procedures(toClase._Procedure_Count)
			ENDIF

			WITH THIS
				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					IF NOT .lineaExcluida( I, tnBloquesExclusion, @taBloquesExclusion ) ;
							AND NOT .lineIsOnlyCommentAndNoMetadata( @tcLine, @tc_Comentario )

						DO CASE
						CASE LEFT( tcLine, 8 ) + ' ' == C_ENDPROC + ' ' && Fin del PROCEDURE
							tcProcedureAbierto	= ''
							EXIT

						CASE LEFT( tcLine + ' ', 10 ) == C_ENDDEFINE + ' '	&& Fin de bloque (ENDDEFINE) encontrado
							IF llEsProcedureDeClase
								ERROR 'Error de anidamiento de estructuras. Se esperaba ENDPROC y se encontr� ENDDEFINE en la clase ' ;
									+ toClase._Nombre + ' (' + loProcedure._Nombre + ')' ;
									+ ', l�nea ' + TRANSFORM(I) + ' del archivo ' + THIS.c_InputFile
							ELSE
								ERROR 'Error de anidamiento de estructuras. Se esperaba ENDPROC y se encontr� ENDDEFINE en la clase ' ;
									+ toClase._Nombre + ' (' + toObjeto._Nombre + '.' + loProcedure._Nombre + ')' ;
									+ ', l�nea ' + TRANSFORM(I) + ' del archivo ' + THIS.c_InputFile
							ENDIF
						ENDCASE
					ENDIF

					*-- Quito 2 TABS de la izquierda (si se puede y si el integrador/desarrollador no la li� quit�ndolos)
					DO CASE
					CASE LEFT( taCodeLines(I),2 ) = C_TAB + C_TAB
						loProcedure.add_Line( SUBSTR(taCodeLines(I), 3) )
					CASE LEFT( taCodeLines(I),1 ) = C_TAB
						loProcedure.add_Line( SUBSTR(taCodeLines(I), 2) )
					OTHERWISE
						loProcedure.add_Line( taCodeLines(I) )
					ENDCASE
				ENDFOR
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ADD_OBJECT
		LPARAMETERS toModulo, toClase, tcLine, I, taCodeLines, tnCodeLines

		EXTERNAL ARRAY taCodeLines

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado

			IF LEFT( tcLine, 11 ) == 'ADD OBJECT '
				*-- Estructura a reconocer: ADD OBJECT 'frm_a.Check1' AS check [WITH]
				llBloqueEncontrado	= .T.
				LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count, Z, lcProp, lcValue
				tcLine		= CHRTRAN( tcLine, ['], ["] )

				IF EMPTY(toClase._Fin_Cab)
					toClase._Fin_Cab	= I-1
					toClase._Ini_Cuerpo	= I
				ENDIF

				toObjeto			= NULL
				toObjeto			= CREATEOBJECT('CL_OBJETO')
				toClase.add_Object( toObjeto )
				toObjeto._Nombre	= ALLTRIM( CHRTRAN( STREXTRACT(tcLine, 'ADD OBJECT ', ' AS ', 1, 1), ['"], [] ) )

				IF '.' $ toObjeto._Nombre
					toObjeto._ObjName	= JUSTEXT( toObjeto._Nombre )
					toObjeto._Parent	= toClase._ObjName + '.' + JUSTSTEM( toObjeto._Nombre )
				ELSE
					toObjeto._ObjName	= toObjeto._Nombre
					toObjeto._Parent	= toClase._ObjName
				ENDIF

				toObjeto._Nombre	= toObjeto._Parent + '.' + toObjeto._ObjName
				toObjeto._Class		= ALLTRIM( STREXTRACT(tcLine + ' WITH', ' AS ', ' WITH', 1, 1) )


				*-- Propiedades del ADD OBJECT
				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						.set_Line( @tcLine, @taCodeLines, I )

						IF LEFT( tcLine, C_LEN_END_OBJECT_I) == C_END_OBJECT_I && Fin del ADD OBJECT y METADATOS
							*< END OBJECT: baseclass = "olecontrol" Uniqueid = "_3X50L3I7V" OLEObject = "C:\WINDOWS\system32\FOXTLIB.OCX" checksum = "4101493921" />

							.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count ;
								, C_END_OBJECT_I, C_END_OBJECT_F )

							toObjeto._ClassLib			= .get_ValueByName_FromListNamesWithValues( 'ClassLib', 'C', @laPropsAndValues )
							toObjeto._BaseClass			= .get_ValueByName_FromListNamesWithValues( 'BaseClass', 'C', @laPropsAndValues )
							toObjeto._UniqueID			= .get_ValueByName_FromListNamesWithValues( 'UniqueID', 'C', @laPropsAndValues )
							toObjeto._Ole2				= .get_ValueByName_FromListNamesWithValues( 'OLEObject', 'C', @laPropsAndValues )
							toObjeto._ZOrder			= .get_ValueByName_FromListNamesWithValues( 'ZOrder', 'I', @laPropsAndValues )
							toObjeto._TimeStamp			= INT( .RowTimeStamp( .get_ValueByName_FromListNamesWithValues( 'TimeStamp', 'T', @laPropsAndValues ) ) )

							IF NOT EMPTY( toObjeto._Ole2 )	&& Le agrego "OLEObject = " delante
								toObjeto._Ole2		= 'OLEObject = ' + toObjeto._Ole2 + CR_LF
							ENDIF

							*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
							IF toModulo.existeObjetoOLE( toObjeto._Nombre, @Z )
								toObjeto._Ole	= toModulo._Ole_Objs(Z)._Value
							ENDIF

							EXIT
						ENDIF

						IF RIGHT(tcLine, 3) == ', ;'	&& VALOR INTERMEDIO CON ", ;"
							*toObjeto.add_Property( .desnormalizarAsignacion( LEFT(tcLine, LEN(tcLine) - 3) ) )
							.get_SeparatedPropAndValue( LEFT(tcLine, LEN(tcLine) - 3), @lcProp, @lcValue )
							toObjeto.add_Property( @lcProp, @lcValue )
						ELSE	&& VALOR FINAL SIN ", ;" (JUSTO ANTES DEL <END OBJECT>)
							*toObjeto.add_Property( .desnormalizarAsignacion( RTRIM(tcLine) ) )
							.get_SeparatedPropAndValue( RTRIM(tcLine), @lcProp, @lcValue )
							toObjeto.add_Property( @lcProp, @lcValue )
						ENDIF

					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DEFINED_PAM
		*--------------------------------------------------------------------------------------------------------------
		* 07/01/2014	FDBOZZO		Los *m�todos deben ir siempre al final, si no los eventos ACCESS no se ejecutan!
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toClase					(!@ IN    ) Objeto de la Clase
		* tcLine					(!@ IN    ) L�nea de datos en evaluaci�n
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo de texto donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* I							(!@ IN    ) N�mero de l�nea en evaluaci�n
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS toClase, tcLine, taCodeLines, tnCodeLines, I

		*-- ESTRUCTURA A ANALIZAR:
		*<DefinedPropArrayMethod>
		*m: *metodovacio_con_comentarios		&& Este m�todo no tiene c�digo, pero tiene comentarios. A ver que pasa!
		*m: *mimetodo		&& Mi metodo
		*p: prop1		&& Mi prop 1
		*p: prop_especial_cr		&&
		*a: ^array_1_d[1,0]		&& Array 1 dimensi�n (1)
		*a: ^array_2_d[1,2]		&& Array una dimension (1,2)
		*p: _memberdata		&& XML Metadata for customizable properties
		*</DefinedPropArrayMethod>

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcDefinedPAM, lnPos, lnPos2, lcPAM_Name, lcItem, lcMethods

			IF LEFT( tcLine, C_LEN_DEFINED_PAM_I) == C_DEFINED_PAM_I
				llBloqueEncontrado	= .T.
				STORE '' TO lcDefinedPAM, lcItem, lcMethods

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, C_LEN_DEFINED_PAM_F ) == C_DEFINED_PAM_F
							I = I + 1
							EXIT

						OTHERWISE
							lnPos			= AT( ' ', tcLine, 1 )
							lnPos2			= AT( '&'+'&', tcLine )

							IF lnPos2 > 0
								*-- Con comentarios
								lcPAM_Name		= RTRIM( SUBSTR( tcLine, lnPos+1, lnPos2 - lnPos - 1 ), 0, ' ', CHR(9) )
								lcItem	= lcPAM_Name + ' ' + SUBSTR( tcLine, lnPos2 + 3 ) + CR_LF

								*-- Separo propiedades y m�todos
								IF LEFT(lcItem,1) == '*'
									lcMethods		= lcMethods + lcItem
								ELSE
									lcDefinedPAM	= lcDefinedPAM + lcItem
								ENDIF
							ELSE
								*-- Sin comentarios
								lcPAM_Name		= RTRIM( SUBSTR( tcLine, lnPos+1 ), 0, ' ', CHR(9) )
								lcItem	= lcPAM_Name + IIF(ISALPHA(lcPAM_Name), '', ' ') + CR_LF

								*-- Separo propiedades y m�todos
								IF LEFT(lcItem,1) == '*'
									lcMethods		= lcMethods + lcItem
								ELSE
									lcDefinedPAM	= lcDefinedPAM + lcItem
								ENDIF
							ENDIF
						ENDCASE
					ENDFOR
				ENDWITH && THIS

				*-- Junto propiedades y los m�todos al final.
				toClase._Defined_PAM	= lcDefinedPAM + lcMethods
				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DEFINE_CLASS
		LPARAMETERS toModulo, toClase, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto ;
			, taBloquesExclusion, tnBloquesExclusion, tc_Comentario

		EXTERNAL ARRAY taCodeLines, tnBloquesExclusion, taBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine + ' ', 13) == C_DEFINE_CLASS + ' '
			TRY
				llBloqueEncontrado = .T.
				LOCAL Z, lcProp, lcValue, loEx AS EXCEPTION ;
					, llMETADATA_Completed, llPROTECTED_Completed, llHIDDEN_Completed, llDEFINED_PAM_Completed ;
					, llINCLUDE_Completed, llCLASS_PROPERTY_Completed ;
					, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

				STORE '' TO tcProcedureAbierto
				toClase					= CREATEOBJECT('CL_CLASE')
				toClase._Nombre			= ALLTRIM( STREXTRACT( tcLine, 'DEFINE CLASS ', ' AS ', 1, 1 ) )
				toClase._ObjName		= toClase._Nombre
				toClase._Definicion		= ALLTRIM( tcLine )
				IF NOT ' OF ' $ UPPER(tcLine)	&& Puede no tener "OF libreria.vcx"
					toClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OLEPUBLIC', ' AS ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
				ELSE
					toClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OF ', ' AS ', ' OF ', 1, 1 ), ["'], [] ) )
				ENDIF
				toClase._ClassLoc		= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OLEPUBLIC', ' OF ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
				toClase._OlePublic		= ' OLEPUBLIC' $ UPPER(tcLine)
				toClase._Comentario		= tc_Comentario
				toClase._Inicio			= I
				toClase._Ini_Cab		= I + 1

				toModulo.add_Class( toClase )

				*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
				IF toModulo.existeObjetoOLE( toClase._Nombre, @Z )
					toClase._Ole	= toModulo._Ole_Objs(Z)._Value
				ENDIF

				* B�squeda del ID de fin de bloque (ENDDEFINE)
				WITH THIS
					FOR I = toClase._Ini_Cab TO tnCodeLines
						tc_Comentario	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @tc_Comentario )
							LOOP

						CASE .analizarBloque_PROCEDURE( @toModulo, @toClase, @loObjeto, @tcLine, @taCodeLines, @I, @tnCodeLines ;
								, @tcProcedureAbierto, @tc_Comentario, @taBloquesExclusion, @tnBloquesExclusion )
							*-- OJO: Esta se analiza primero a prop�sito, solo porque no puede estar detr�s de PROTECTED y HIDDEN
							llCLASS_PROPERTY_Completed = .T.
							llPROTECTED_Completed	= .T.
							llHIDDEN_Completed	= .T.
							llINCLUDE_Completed	= .T.
							llMETADATA_Completed	= .T.
							llDEFINED_PAM_Completed	= .T.


						CASE NOT llPROTECTED_Completed AND .analizarBloque_PROTECTED( @toClase, @tcLine )
							llPROTECTED_Completed	= .T.


						CASE NOT llHIDDEN_Completed AND .analizarBloque_HIDDEN( @toClase, @tcLine )
							llHIDDEN_Completed	= .T.


						CASE NOT llINCLUDE_Completed AND .c_Type <> "SCX" AND .analizarBloque_INCLUDE( @toModulo, @toClase, @tcLine, @taCodeLines ;
								, @I, @tnCodeLines, @tcProcedureAbierto )
							llINCLUDE_Completed	= .T.


						CASE NOT llMETADATA_Completed AND .analizarBloque_METADATA( @toClase, @tcLine )
							llMETADATA_Completed	= .T.


						CASE NOT llDEFINED_PAM_Completed AND .analizarBloque_DEFINED_PAM( @toClase, @tcLine, @taCodeLines, tnCodeLines, @I )
							llDEFINED_PAM_Completed	= .T.


						CASE .analizarBloque_ADD_OBJECT( @toModulo, @toClase, @tcLine, @I, @taCodeLines, @tnCodeLines )
							llCLASS_PROPERTY_Completed = .T.
							llPROTECTED_Completed	= .T.
							llHIDDEN_Completed	= .T.
							llINCLUDE_Completed	= .T.
							llMETADATA_Completed	= .T.
							llDEFINED_PAM_Completed	= .T.


						CASE .analizarBloque_ENDDEFINE( @toClase, @tcLine, @I, @tcProcedureAbierto )
							EXIT


						CASE NOT llCLASS_PROPERTY_Completed AND EMPTY( toClase._Fin_Cab )
							*-- Propiedades de la CLASE
							*--
							*-- NOTA: Las propiedades se agregan tal cual, incluso aunque est�n separadas en
							*--       varias l�neas (memberdata y fb2p_value), ya que luego se ensamblan en classProps2Memo().
							*
							*toClase.add_Property( THIS.desnormalizarAsignacion( RTRIM(tcLine) ), RTRIM(tc_Comentario) )
							.get_SeparatedPropAndValue( RTRIM(tcLine), @lcProp, @lcValue, @toClase, @taCodeLines, tnCodeLines, @I )
							toClase.add_Property( @lcProp, @lcValue, RTRIM(tc_Comentario) )


						OTHERWISE
							*-- Las l�neas que pasan por aqu� deber�an estar vac�as y ser de relleno del embellecimiento

						ENDCASE

					ENDFOR
				ENDWITH && THIS

				*-- Validaci�n
				IF EMPTY( toClase._Fin )
					ERROR 'No se ha encontrado el marcador de fin [ENDDEFINE] ' ;
						+ 'que cierra al marcador de inicio [DEFINE CLASS] ' ;
						+ 'de la l�nea ' + TRANSFORM( toClase._Inicio ) + ' ' ;
						+ 'para el identificador [' + toClase._Nombre + ']'
				ENDIF

				toClase._PROPERTIES		= THIS.classProps2Memo( toClase )
				toClase._PROTECTED		= THIS.hiddenAndProtected_PAM( toClase )
				toClase._METHODS		= THIS.classMethods2Memo( toClase )
				toClase._RESERVED1		= IIF( THIS.c_Type = 'SCX', '', 'Class' )
				toClase._RESERVED2		= IIF( THIS.c_Type = 'VCX' OR toClase._Nombre == 'Dataenvironment', TRANSFORM( toClase._AddObject_Count + 1 ), '' )
				toClase._RESERVED3		= THIS.defined_PAM2Memo( toClase )
				toClase._RESERVED4		= toClase._ClassIcon
				toClase._RESERVED5		= toClase._ProjectClassIcon
				toClase._RESERVED6		= toClase._Scale
				toClase._RESERVED7		= toClase._Comentario
				toClase._RESERVED8		= toClase._includeFile

			CATCH TO loEx
				IF THIS.l_Debug AND _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF

				THROW

			ENDTRY
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ENDDEFINE
		LPARAMETERS toClase, tcLine, I, tcProcedureAbierto

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT( tcLine + ' ', 10 ) == C_ENDDEFINE + ' '	&& Fin de bloque (ENDDEF / ENDPROC) encontrado
			llBloqueEncontrado	= .T.
			toClase._Fin		= I

			IF EMPTY( toClase._Ini_Cuerpo )
				toClase._Ini_Cuerpo	= I-1
			ENDIF

			toClase._Fin_Cuerpo	= I-1

			IF EMPTY( toClase._Fin_Cab )
				toClase._Fin_Cab	= I-1
			ENDIF

			STORE '' TO tcProcedureAbierto
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_HIDDEN
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, 7) == 'HIDDEN '
			llBloqueEncontrado	= .T.
			toClase._HiddenProps		= ALLTRIM( SUBSTR( tcLine, 8 ) )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_INCLUDE
		LPARAMETERS toModulo, toClase, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto
		LOCAL llBloqueEncontrado

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF LEFT(tcLine, 9) == '#INCLUDE '
			llBloqueEncontrado		= .T.
			IF THIS.c_Type = 'SCX'
				toModulo._includeFile	= ALLTRIM( CHRTRAN( SUBSTR( tcLine, 10 ), ["'], [] ) )
			ELSE
				toClase._includeFile	= ALLTRIM( CHRTRAN( SUBSTR( tcLine, 10 ), ["'], [] ) )
			ENDIF
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_METADATA
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, C_LEN_METADATA_I) == C_METADATA_I	&& METADATA de la CLASE
			*< CLASSDATA: Baseclass="custom" Timestamp="2013/11/19 11:51:04" Scale="Foxels" Uniqueid="_3WF0VSTN1" ProjectClassIcon="container.ico" ClassIcon="toolbar.ico" />
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count
			llBloqueEncontrado	= .T.
			WITH THIS
				.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_METADATA_I, C_METADATA_F )

				toClase._BaseClass			= .get_ValueByName_FromListNamesWithValues( 'BaseClass', 'C', @laPropsAndValues )
				toClase._TimeStamp			= INT( .RowTimeStamp(  .get_ValueByName_FromListNamesWithValues( 'TimeStamp', 'T', @laPropsAndValues ) ) )
				toClase._Scale				= .get_ValueByName_FromListNamesWithValues( 'Scale', 'C', @laPropsAndValues )
				toClase._UniqueID			= .get_ValueByName_FromListNamesWithValues( 'UniqueID', 'C', @laPropsAndValues )
				toClase._ProjectClassIcon	= .get_ValueByName_FromListNamesWithValues( 'ProjectClassIcon', 'C', @laPropsAndValues )
				toClase._ClassIcon			= .get_ValueByName_FromListNamesWithValues( 'ClassIcon', 'C', @laPropsAndValues )
				toClase._Ole2				= .get_ValueByName_FromListNamesWithValues( 'OLEObject', 'C', @laPropsAndValues )
			ENDWITH && THIS

			IF NOT EMPTY( toClase._Ole2 )	&& Le agrego "OLEObject = " delante
				toClase._Ole2	= 'OLEObject = ' + toClase._Ole2 + CR_LF
			ENDIF
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_OLE_DEF
		LPARAMETERS toModulo, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto
		LOCAL llBloqueEncontrado

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF LEFT( tcLine + ' ', C_LEN_OLE_I + 1 ) == C_OLE_I + ' '
			llBloqueEncontrado	= .T.
			*-- Se encontr� una definici�n de objeto OLE
			*< OLE: Nombre="frm_d.ole_ImageControl2" parent="frm_d" objname="ole_ImageControl2" checksum="4171274922" value="b64-value" />
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loOle AS CL_OLE OF 'FOXBIN2PRG.PRG'
			loOle			= NULL
			loOle			= CREATEOBJECT('CL_OLE')

			WITH THIS
				.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_OLE_I, C_OLE_F )

				loOle._Nombre		= .get_ValueByName_FromListNamesWithValues( 'Nombre', 'C', @laPropsAndValues )
				loOle._Parent		= .get_ValueByName_FromListNamesWithValues( 'Parent', 'C', @laPropsAndValues )
				loOle._ObjName		= .get_ValueByName_FromListNamesWithValues( 'ObjName', 'C', @laPropsAndValues )
				loOle._CheckSum		= .get_ValueByName_FromListNamesWithValues( 'CheckSum', 'C', @laPropsAndValues )
				loOle._Value		= STRCONV( .get_ValueByName_FromListNamesWithValues( 'Value', 'C', @laPropsAndValues ), 14 )
			ENDWITH

			toModulo.add_OLE( loOle )

			IF EMPTY( loOle._Value )
				*-- Si el objeto OLE no tiene VALUE, es porque hay otro con el mismo contenido y no se duplic� para preservar espacio.
				*-- Busco el VALUE del duplicado que se guard� y lo asigno nuevamente
				FOR Z = 1 TO toModulo._Ole_Obj_count - 1
					IF toModulo._Ole_Objs(Z)._CheckSum == loOle._CheckSum AND NOT EMPTY( toModulo._Ole_Objs(Z)._Value )
						loOle._Value	= toModulo._Ole_Objs(Z)._Value
						EXIT
					ENDIF
				ENDFOR
			ENDIF

			loOle	= NULL
			RELEASE loOle
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_PROCEDURE
		LPARAMETERS toModulo, toClase, toObjeto, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto ;
			, tc_Comentario, taBloquesExclusion, tnBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		DO CASE
		CASE LEFT( tcLine, 20 ) == 'PROTECTED PROCEDURE '
			*-- Estructura a reconocer: PROTECTED PROCEDURE nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 21 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'protected', @toObjeto )


		CASE LEFT( tcLine, 17 ) == 'HIDDEN PROCEDURE '
			*-- Estructura a reconocer: HIDDEN PROCEDURE nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 18 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'hidden', @toObjeto )

		CASE LEFT( tcLine, 10 ) == 'PROCEDURE '
			*-- Estructura a reconocer: PROCEDURE [objeto.]nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 11 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'normal', @toObjeto )

		ENDCASE

		IF llBloqueEncontrado
			*-- Eval�o todo el contenido del PROCEDURE
			THIS.analizarLineasDeProcedure( @toClase, @toObjeto, @tcLine, @taCodeLines, @I, @tnCodeLines, @tcProcedureAbierto ;
				, @tc_Comentario, @taBloquesExclusion, @tnBloquesExclusion )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_PROTECTED
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, 10) == 'PROTECTED '
			llBloqueEncontrado	= .T.
			toClase._ProtectedProps		= ALLTRIM( SUBSTR( tcLine, 11 ) )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE evaluarDefinicionDeProcedure
		LPARAMETERS toClase, tnX, tc_Comentario, tcProcName, tcProcType, toObjeto
		*--------------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lcNombreObjeto, lnObjProc ;
				, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'

			IF EMPTY(toClase._Fin_Cab)
				toClase._Fin_Cab	= tnX-1
				toClase._Ini_Cuerpo	= tnX
			ENDIF

			loProcedure		= CREATEOBJECT("CL_PROCEDURE")
			loProcedure._Nombre			= tcProcName
			loProcedure._ProcType		= tcProcType
			loProcedure._Comentario		= tc_Comentario

			*-- Anoto en HiddenMethods y ProtectedMethods seg�n corresponda
			DO CASE
			CASE loProcedure._ProcType == 'hidden'
				toClase._HiddenMethods	= toClase._HiddenMethods + ',' + tcProcName

			CASE loProcedure._ProcType == 'protected'
				toClase._ProtectedMethods	= toClase._ProtectedMethods + ',' + tcProcName

			ENDCASE

			*-- Agrego el objeto Procedimiento a la clase, o a un objeto de la clase.
			IF '.' $ tcProcName
				*-- Procedimiento de objeto
				lcNombreObjeto	= LOWER( JUSTSTEM( tcProcName ) )

				*-- Busco el objeto al que corresponde el m�todo
				lnObjProc	= THIS.buscarObjetoDelMetodoPorNombre( lcNombreObjeto, toClase )

				IF lnObjProc = 0
					*-- Procedimiento de clase
					toClase.add_Procedure( loProcedure )
					toObjeto	= NULL
				ELSE
					*-- Procedimiento de objeto
					toObjeto	= toClase._AddObjects( lnObjProc )
					toObjeto.add_Procedure( loProcedure )
				ENDIF
			ELSE
				*-- Procedimiento de clase
				toClase.add_Procedure( loProcedure )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loProcedure
			RELEASE loProcedure

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusi�n
		* toModulo					(?@    OUT) Objeto con toda la informaci�n del m�dulo analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, seg�n corresponda.
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toModulo

		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, loEx AS EXCEPTION ;
				, llFoxBin2Prg_Completed, llOLE_DEF_Completed, llINCLUDE_SCX_Completed ;
				, lc_Comentario, lcProcedureAbierto, lcLine ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'

			STORE '' TO lcProcedureAbierto

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1

				*-- Defino el objeto de m�dulo y sus propiedades
				toModulo	= NULL
				toModulo	= CREATEOBJECT('CL_MODULO')

				*-- B�squeda del ID de inicio de bloque (DEFINE CLASS / PROCEDURE)
				WITH THIS
					FOR I = 1 TO tnCodeLines
						STORE '' TO lc_Comentario
						.set_Line( @lcLine, @taCodeLines, I )

						DO CASE
						CASE THIS.lineaExcluida( I, tnBloquesExclusion, @taBloquesExclusion ) ;
								OR .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Excluida, vac�a o solo Comentarios

						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toModulo, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llOLE_DEF_Completed AND .analizarBloque_OLE_DEF( @toModulo, @lcLine, @taCodeLines ;
								, @I, tnCodeLines, @lcProcedureAbierto )
							*-- Puede haber varios

						CASE NOT llINCLUDE_SCX_Completed AND .c_Type = 'SCX' AND .analizarBloque_INCLUDE( @toModulo, @loClase, @lcLine ;
								, @taCodeLines, @I, tnCodeLines, @lcProcedureAbierto )
							* Espec�fico para SCX que lo tiene al inicio
							llINCLUDE_SCX_Completed	= .T.

						CASE .analizarBloque_DEFINE_CLASS( @toModulo, @loClase, @lcLine, @taCodeLines, @I, tnCodeLines ;
								, @lcProcedureAbierto, @taBloquesExclusion, @tnBloquesExclusion, @lc_Comentario )
							*-- Puede haber varias

						ENDCASE

					ENDFOR
				ENDWITH	&& THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loClase
			RELEASE loClase
		ENDTRY

		RETURN
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_vcx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_vcx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" display="escribirArchivoBin"/>] ;
		+ [</VFPData>]


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_MODULO con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo la librer�a
			THIS.createClasslib()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCodeLines, lnCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo, toFoxbin2prg )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo, toFoxbin2prg
		*-- Estructura del objeto toModulo generado:
		*-- -----------------------------------------------------------------------------------------------------------
		*-- Version					Versi�n usada para generar la versi�n PRG analizada
		*-- SourceFile				Nombre original del archivo fuente de la conversi�n
		*-- Ole_Obj_Count			Cantidad de objetos definidos en el array ole_objs[]
		*-- Ole_Objs[1]				Array de objetos OLE definidos como clases
		*--		ObjName					Nombre del objeto OLE (OLE2)
		*--		Parent					Nombre del objeto Padre
		*--		CheckSum				Suma de verificaci�n
		*--		Value					Valor del campo OLE
		*-- Clases_Count				Array con las posiciones de los addobjects, definicion y propiedades
		*-- Clases[1]				Array con los datos de las clases, definicion, propiedades y m�todos
		*-- 	Nombre					El nombre de la clase (ej: "miClase")
		*--		ObjName					Nombre del objeto
		*--		Parent					Nombre del objeto Padre
		*-- 	Class					Clase de la que hereda la definici�n
		*-- 	Classloc				Librer�a donde est� la definici�n de la clase
		*--		Ole						Informaci�n campo ole
		*--		Ole2					Informaci�n campo ole2
		*--		OlePublic				Indica si la clase es OLEPublic o no (.T. / .F.)
		*-- 	Uniqueid				ID �nico
		*-- 	Comentario				El comentario de la clase (ej: "&& Mis comentarios")
		*-- 	MetaData				Informaci�n de metadata de la clase (baseclass, timestamp, scale)
		*-- 	BaseClass				Clase de base de la clase
		*-- 	TimeStamp				Timestamp de la clase
		*-- 	Scale					Scale de la clase (pixels, foxels)
		*-- 	Definicion				La definici�n de la clase (ej: "AS Custom OF LIBRERIA.VCX")
		*-- 	Inicio/Fin				L�nea de inicio/fin de la clase (DEFINE CLASS/ENDDEFINE)
		*-- 	Ini_Cab/Fin_Cab			L�nea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PAM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	L�nea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PAM				Propiedades, eventos o m�todos definidos por el usuario
		*-- 	IncludeFile				Nombre del archivo de inclusi�n
		*-- 	Props_Count				Cantidad de propiedades de la clase definicas en el array props[]
		*-- 	Props[1,2]				Array con todas las propiedades de la clase y sus valores. (col.1=Nombre, col.2=Comentario)
		*-- 	AddObject_Count			Cantidad de objetos definidos en el array addobjects[]
		*-- 	AddObjects[1]			Array con las posiciones de los addobjects, definicion y propiedades
		*-- 		Nombre					Nombre del objeto
		*--			ObjName					Nombre del objeto
		*--			Parent					Nombre del objeto Padre
		*-- 		Clase					Clase del objeto
		*-- 		ClassLib				Librer�a de clases de la que deriva la clase
		*-- 		Baseclass				Clase de base del objeto
		*-- 		Uniqueid				ID �nico
		*--			Ole						Informaci�n campo ole
		*--			Ole2					Informaci�n campo ole2
		*--			ZOrder					Orden Z del objeto
		*-- 		Props_Count				Cantidad de propiedades del objeto
		*-- 		Props[1]				Array con todas las propiedades del objeto y sus valores
		*-- 		Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 		Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 			Nombre					Nombre del procedure
		*-- 			ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 			Comentario				Comentario el procedure
		*-- 			ProcLine_Count			Cantidad de l�neas del procedimiento
		*-- 			ProcLines[1]			L�neas del procedimiento
		*-- 	Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 	Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 		Nombre					Nombre del procedure
		*-- 		ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 		Comentario				Comentario el procedure
		*-- 		ProcLine_Count			Cantidad de l�neas del procedimiento
		*-- 		ProcLines[1]			L�neas del procedimiento
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcObjName, lnCodError, I, X, loEx AS EXCEPTION ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG' ;
				, loFSO AS Scripting.FileSystemObject

			loFSO	= THIS.oFSO

			*-- Creo el registro de cabecera
			THIS.createClasslib_RecordHeader()


			*-- Recorro las CLASES
			FOR I = 1 TO toModulo._Clases_Count

				loClase	= toModulo._Clases(I)

				*-- Inserto la clase
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'WINDOWS' ;
					, loClase._UniqueID ;
					, loClase._TimeStamp ;
					, loClase._Class ;
					, loClase._ClassLoc ;
					, loClase._BaseClass ;
					, loClase._ObjName ;
					, loClase._Parent ;
					, loClase._PROPERTIES ;
					, loClase._PROTECTED ;
					, loClase._METHODS ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, loClase._RESERVED1 ;
					, loClase._RESERVED2 ;
					, loClase._RESERVED3 ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._includeFile ;
					, loClase._User )


				THIS.insert_AllObjects( @loClase )


				*-- Inserto el COMMENT
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'COMMENT' ;
					, 'RESERVED' ;
					, loClase._TimeStamp ;
					, '' ;
					, '' ;
					, '' ;
					, loClase._ObjName ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, IIF(loClase._OlePublic, 'OLEPublic', '') ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' )

			ENDFOR	&& I = 1 TO toModulo._Clases_Count

			USE IN (SELECT("TABLABIN"))

			IF toFoxbin2prg.l_Recompile
				COMPILE CLASSLIB (THIS.c_OutputFile)
			ENDIF


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError

	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_scx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_scx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" display="escribirArchivoBin"/>] ;
		+ [</VFPData>]


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_MODULO con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo el form
			THIS.createForm()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCodeLines, lnCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo, toFoxbin2prg )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo, toFoxbin2prg
		*-- Estructura del objeto toModulo generado:
		*-- -----------------------------------------------------------------------------------------------------------
		*-- Version					Versi�n usada para generar la versi�n PRG analizada
		*-- SourceFile				Nombre original del archivo fuente de la conversi�n
		*-- Ole_Obj_Count			Cantidad de objetos definidos en el array ole_objs[]
		*-- Ole_Objs[1]				Array de objetos OLE definidos como clases
		*--		ObjName					Nombre del objeto OLE (OLE2)
		*--		Parent					Nombre del objeto Padre
		*--		CheckSum				Suma de verificaci�n
		*--		Value					Valor del campo OLE
		*-- Clases_Count				Array con las posiciones de los addobjects, definicion y propiedades
		*-- Clases[1]				Array con los datos de las clases, definicion, propiedades y m�todos
		*-- 	Nombre					El nombre de la clase (ej: "miClase")
		*--		ObjName					Nombre del objeto
		*--		Parent					Nombre del objeto Padre
		*-- 	Class					Clase de la que hereda la definici�n
		*-- 	Classloc				Librer�a donde est� la definici�n de la clase
		*--		Ole						Informaci�n campo ole
		*--		Ole2					Informaci�n campo ole2
		*--		OlePublic				Indica si la clase es OLEPublic o no (.T. / .F.)
		*-- 	Uniqueid				ID �nico
		*-- 	Comentario				El comentario de la clase (ej: "&& Mis comentarios")
		*-- 	MetaData				Informaci�n de metadata de la clase (baseclass, timestamp, scale)
		*-- 	BaseClass				Clase de base de la clase
		*-- 	TimeStamp				Timestamp de la clase
		*-- 	Scale					Scale de la clase (pixels, foxels)
		*-- 	Definicion				La definici�n de la clase (ej: "AS Custom OF LIBRERIA.VCX")
		*-- 	Inicio/Fin				L�nea de inicio/fin de la clase (DEFINE CLASS/ENDDEFINE)
		*-- 	Ini_Cab/Fin_Cab			L�nea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PAM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	L�nea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PAM				Propiedades, eventos o m�todos definidos por el usuario
		*-- 	IncludeFile				Nombre del archivo de inclusi�n
		*-- 	Props_Count				Cantidad de propiedades de la clase definicas en el array props[]
		*-- 	Props[1,2]				Array con todas las propiedades de la clase y sus valores. (col.1=Nombre, col.2=Comentario)
		*-- 	AddObject_Count			Cantidad de objetos definidos en el array addobjects[]
		*-- 	AddObjects[1]			Array con las posiciones de los addobjects, definicion y propiedades
		*-- 		Nombre					Nombre del objeto
		*--			ObjName					Nombre del objeto
		*--			Parent					Nombre del objeto Padre
		*-- 		Clase					Clase del objeto
		*-- 		ClassLib				Librer�a de clases de la que deriva la clase
		*-- 		Baseclass				Clase de base del objeto
		*-- 		Uniqueid				ID �nico
		*--			Ole						Informaci�n campo ole
		*--			Ole2					Informaci�n campo ole2
		*--			ZOrder					Orden Z del objeto
		*-- 		Props_Count				Cantidad de propiedades del objeto
		*-- 		Props[1]				Array con todas las propiedades del objeto y sus valores
		*-- 		Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 		Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 			Nombre					Nombre del procedure
		*-- 			ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 			Comentario				Comentario el procedure
		*-- 			ProcLine_Count			Cantidad de l�neas del procedimiento
		*-- 			ProcLines[1]			L�neas del procedimiento
		*-- 	Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 	Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 		Nombre					Nombre del procedure
		*-- 		ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 		Comentario				Comentario el procedure
		*-- 		ProcLine_Count			Cantidad de l�neas del procedimiento
		*-- 		ProcLines[1]			L�neas del procedimiento
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcObjName, lnCodError, loEx AS EXCEPTION ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

			*-- Creo el registro de cabecera
			THIS.createForm_RecordHeader()

			*-- El SCX tiene el INCLUDE en el primer registro
			IF NOT EMPTY(toModulo._includeFile)
				REPLACE RESERVED8 WITH toModulo._includeFile
			ENDIF


			*-- Recorro las CLASES
			FOR I = 1 TO toModulo._Clases_Count

				loClase	= toModulo._Clases(I)

				*-- Inserto la clase
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'WINDOWS' ;
					, loClase._UniqueID ;
					, loClase._TimeStamp ;
					, loClase._Class ;
					, loClase._ClassLoc ;
					, loClase._BaseClass ;
					, loClase._ObjName ;
					, loClase._Parent ;
					, loClase._PROPERTIES ;
					, loClase._PROTECTED ;
					, loClase._METHODS ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, loClase._RESERVED1 ;
					, loClase._RESERVED2 ;
					, loClase._RESERVED3 ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._includeFile ;
					, loClase._User )


				THIS.insert_AllObjects( @loClase )

			ENDFOR	&& I = 1 TO toModulo._Clases_Count

			*-- Inserto el COMMENT final
			INSERT INTO TABLABIN ;
				( PLATFORM ;
				, UNIQUEID ;
				, TIMESTAMP ;
				, CLASS ;
				, CLASSLOC ;
				, BASECLASS ;
				, OBJNAME ;
				, PARENT ;
				, PROPERTIES ;
				, PROTECTED ;
				, METHODS ;
				, OLE ;
				, OLE2 ;
				, RESERVED1 ;
				, RESERVED2 ;
				, RESERVED3 ;
				, RESERVED4 ;
				, RESERVED5 ;
				, RESERVED6 ;
				, RESERVED7 ;
				, RESERVED8 ;
				, USER) ;
				VALUES ;
				( 'COMMENT' ;
				, 'RESERVED' ;
				, 0 ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' )

			USE IN (SELECT("TABLABIN"))

			IF toFoxbin2prg.l_Recompile
				COMPILE FORM (THIS.c_OutputFile)
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN

	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_pjx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_pjx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="analizarbloque_buildproj" display="analizarBloque_BuildProj"/>] ;
		+ [<memberdata name="analizarbloque_devinfo" display="analizarBloque_DevInfo"/>] ;
		+ [<memberdata name="analizarbloque_excludedfiles" display="analizarBloque_ExcludedFiles"/>] ;
		+ [<memberdata name="analizarbloque_filecomments" display="analizarBloque_FileComments"/>] ;
		+ [<memberdata name="analizarbloque_serverhead" display="analizarBloque_ServerHead"/>] ;
		+ [<memberdata name="analizarbloque_serverdata" display="analizarBloque_ServerData"/>] ;
		+ [<memberdata name="analizarbloque_textfiles" display="analizarBloque_TextFiles"/>] ;
		+ [<memberdata name="analizarbloque_projectproperties" display="analizarBloque_ProjectProperties"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toProject					(@!    OUT) Objeto generado de clase CL_PROJECT con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toProject, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toProject, @toEx )

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo solo la cabecera del proyecto
			THIS.createProject()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			*THIS.identificarBloquesDeExclusion( @laCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toProject )

			THIS.escribirArchivoBin( @toProject )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toProject
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loReg, lnCodError, loEx AS EXCEPTION ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			toProject._HomeDir	= CHRTRAN( toProject._HomeDir, ['], [] )

			*-- Creo solo el registro de cabecera del proyecto
			THIS.createProject_RecordHeader( toProject )

			lcMainProg	= ''

			IF NOT EMPTY(toProject._MainProg)
				lcMainProg	= LOWER( SYS(2014, toProject._MainProg, ADDBS(toProject._HomeDir) ) )
			ENDIF

			*-- Si hay ProjectHook de proyecto, lo inserto
			IF NOT EMPTY(toProject._ProjectHookLibrary)
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, EXCLUDE ;
					, KEY ;
					, RESERVED1 ) ;
					VALUES ;
					( toProject._ProjectHookLibrary + CHR(0) ;
					, 'W' ;
					, .T. ;
					, UPPER(JUSTSTEM(toProject._ProjectHookLibrary)) ;
					, toProject._ProjectHookClass + CHR(0) )
			ENDIF

			*-- Si hay ICONO de proyecto, lo inserto
			IF NOT EMPTY(toProject._Icon)
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, LOCAL ;
					, KEY ) ;
					VALUES ;
					( SYS(2014, toProject._Icon, ADDBS(JUSTPATH(toProject._HomeDir))) + CHR(0) ;
					, 'i' ;
					, .T. ;
					, UPPER(JUSTSTEM(toProject._Icon)) )
			ENDIF

			*-- Agrego los ARCHIVOS
			FOR EACH loFile IN toProject FOXOBJECT
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, EXCLUDE ;
					, MAINPROG ;
					, COMMENTS ;
					, LOCAL ;
					, CPID ;
					, ID ;
					, TIMESTAMP ;
					, OBJREV ;
					, KEY ) ;
					VALUES ;
					( loFile._Name + CHR(0) ;
					, THIS.fileTypeCode(JUSTEXT(loFile._Name)) ;
					, loFile._Exclude ;
					, (loFile._Name == lcMainProg) ;
					, loFile._Comments ;
					, .T. ;
					, loFile._CPID ;
					, loFile._ID ;
					, loFile._TimeStamp ;
					, loFile._ObjRev ;
					, UPPER(JUSTSTEM(loFile._Name)) )
			ENDFOR

			USE IN (SELECT("TABLABIN"))


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toProject
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusi�n
		* toProject					(?@    OUT) Objeto con toda la informaci�n del proyecto analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, seg�n corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llBuildProj_Completed, llDevInfo_Completed ;
				, llServerHead_Completed, llFileComments_Completed, llFoxBin2Prg_Completed ;
				, llExcludedFiles_Completed, llTextFiles_Completed, llProjectProperties_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toProject			= CREATEOBJECT('CL_PROJECT')
				*toProject._HomeDir	= ADDBS(JUSTPATH(THIS.c_OutputFile))

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vac�a o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llDevInfo_Completed AND .analizarBloque_DevInfo( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llDevInfo_Completed	= .T.

						CASE NOT llServerHead_Completed AND .analizarBloque_ServerHead( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llServerHead_Completed	= .T.

						CASE .analizarBloque_ServerData( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							*-- Puede haber varios servidores, por eso se siguen valuando

						CASE NOT llBuildProj_Completed AND .analizarBloque_BuildProj( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llBuildProj_Completed	= .T.

						CASE NOT llFileComments_Completed AND .analizarBloque_FileComments( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFileComments_Completed	= .T.

						CASE NOT llExcludedFiles_Completed AND .analizarBloque_ExcludedFiles( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llExcludedFiles_Completed	= .T.

						CASE NOT llTextFiles_Completed AND .analizarBloque_TextFiles( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llTextFiles_Completed	= .T.

						CASE NOT llProjectProperties_Completed AND .analizarBloque_ProjectProperties( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llProjectProperties_Completed	= .T.

						ENDCASE

					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_BuildProj
		*------------------------------------------------------
		*-- Analiza el bloque <BuildProj>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_BUILDPROJ_I) ) == C_BUILDPROJ_I
				llBloqueEncontrado	= .T.
				STORE NULL TO loProject, loFile

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						lcComment	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, LEN(C_BUILDPROJ_F) ) == C_BUILDPROJ_F
							I = I + 1
							EXIT

						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
							LOOP	&& Saltear comentarios

						CASE UPPER( LEFT( tcLine, 14 ) ) == 'BUILD PROJECT '
							LOOP

						CASE UPPER( LEFT( tcLine, 5 ) ) == '.ADD('
							* loFile: NAME,TYPE,EXCLUDE,COMMENTS
							tcLine			= CHRTRAN( tcLine, ["] + '[]', "'''" )	&& Convierto "[] en '
							loFile			= CREATEOBJECT('CL_PROJ_FILE')
							loFile._Name	= ALLTRIM( STREXTRACT( tcLine, ['], ['] ) )

							*-- Obtengo metadatos de los comentarios de FileMetadata:
							*< FileMetadata: Type="V" Cpid="1252" Timestamp="1131901580" ID="1129207528" ObjRev="544" />
							.get_ListNamesWithValuesFrom_InLine_MetadataTag( @lcComment, @laPropsAndValues ;
								, @lnPropsAndValues_Count, C_FILE_META_I, C_FILE_META_F )

							loFile._Type		= .get_ValueByName_FromListNamesWithValues( 'Type', 'C', @laPropsAndValues )
							loFile._CPID		= .get_ValueByName_FromListNamesWithValues( 'CPID', 'I', @laPropsAndValues )
							loFile._TimeStamp	= .get_ValueByName_FromListNamesWithValues( 'Timestamp', 'I', @laPropsAndValues )
							loFile._ID			= .get_ValueByName_FromListNamesWithValues( 'ID', 'I', @laPropsAndValues )
							loFile._ObjRev		= .get_ValueByName_FromListNamesWithValues( 'ObjRev', 'I', @laPropsAndValues )

							toProject.ADD( loFile, loFile._Name )

						CASE UPPER( LEFT( tcLine, 10 ) ) == UPPER( '*<.HomeDir' )
							toProject._HomeDir	= STREXTRACT( tcLine, "'", "'" )

						ENDCASE
					ENDFOR
				ENDWITH && THIS

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DevInfo
		*------------------------------------------------------
		*-- Analiza el bloque <DevInfo>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_DEVINFO_I) ) == C_DEVINFO_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_DEVINFO_F) ) == C_DEVINFO_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						toProject.setParsedProjInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ServerHead
		*------------------------------------------------------
		*-- Analiza el bloque <ServerHead>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_HEAD_I) ) == C_SRV_HEAD_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_HEAD_F) ) == C_SRV_HEAD_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedHeadInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ServerData
		*------------------------------------------------------
		*-- Analiza el bloque <ServerData>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_DATA_I) ) == C_SRV_DATA_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead
				loServerData	= loServerHead.getServerDataObject()

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_DATA_F) ) == C_SRV_DATA_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedInfoLine( loServerData, @tcLine )
					ENDCASE
				ENDFOR

				loServerHead.add_Server( loServerData )
				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_FileComments
		*------------------------------------------------------
		*-- Analiza el bloque <FileComments>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, lcComment ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_CMTS_I) ) == C_FILE_CMTS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_CMTS_F) ) == C_FILE_CMTS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile				= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						lcComment			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) )
						loFile				= toProject( lcFile )
						loFile._Comments	= lcComment
						loFile				= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ExcludedFiles
		*------------------------------------------------------
		*-- Analiza el bloque <ExcludedFiles>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, llExclude ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_EXCL_I) ) == C_FILE_EXCL_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_EXCL_F) ) == C_FILE_EXCL_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile			= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						llExclude		= EVALUATE( ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) ) )
						loFile			= toProject( lcFile )
						loFile._Exclude	= llExclude
						loFile			= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_TextFiles
		*------------------------------------------------------
		*-- Analiza el bloque <TextFiles>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, lcType ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_TXT_I) ) == C_FILE_TXT_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_TXT_F) ) == C_FILE_TXT_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile			= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						lcType			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) )
						loFile			= toProject( lcFile )
						loFile._Type	= lcType
						loFile			= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ProjectProperties
		*------------------------------------------------------
		*-- Analiza el bloque <ProjectProperties>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcLine

			IF LEFT( tcLine, LEN(C_PROJPROPS_I) ) == C_PROJPROPS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_PROJPROPS_F) ) == C_PROJPROPS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					CASE LEFT( tcLine ,2 ) == '*<'
						*--- Se asigna con EVALUATE() tal cual est� en el PJ2, pero quitando el marcador *< />
						lcLine		= STUFF( ALLTRIM( STREXTRACT( tcLine, '*<', '/>' ) ), 2, 0, '_' )
						toProject.setParsedProjInfoLine( lcLine )

					CASE UPPER( LEFT( tcLine, 9 ) ) == '.SETMAIN('
						*-- Cambio "SetMain()" por "_MainProg ="
						lcLine		= '._MainProg = ' + LOWER( STREXTRACT( ALLTRIM( tcLine), '.SetMain(', ')', 1, 1 ) )
						toProject.setParsedProjInfoLine( lcLine )

					OTHERWISE
						*--- Se asigna con EVALUATE() tal cual est� en el PJ2
						lcLine		= STUFF( ALLTRIM( tcLine), 2, 0, '_' )
						toProject.setParsedProjInfoLine( lcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_frx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_frx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="analizarbloque_cdata_inline" display="analizarBloque_CDATA_inline"/>] ;
		+ [<memberdata name="analizarbloque_platform" display="analizarBloque_platform"/>] ;
		+ [<memberdata name="analizarbloque_reportes" display="analizarBloque_Reportes"/>] ;
		+ [</VFPData>]


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toReport					(@!    OUT) Objeto generado de clase CL_REPORT con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toReport, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toReport, @toEx )

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo el reporte
			THIS.createReport()

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo del reporte
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toReport )

			THIS.escribirArchivoBin( @toReport, toFoxbin2prg )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toReport, toFoxbin2prg
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loReg, I, lcFieldType, lnFieldLen, lnFieldDec, lnNumCampo, laFieldTypes(1,18) ;
				, luValor, lnCodError, loEx AS EXCEPTION
			SELECT TABLABIN
			AFIELDS( laFieldTypes )

			*-- Agrego los registros
			FOR EACH loReg IN toReport FOXOBJECT

				*-- Ajuste de los tipos de dato
				FOR I = 1 TO AMEMBERS(laProps, loReg, 0)
					lnNumCampo	= ASCAN( laFieldTypes, laProps(I), 1, -1, 1, 1+2+4+8 )

					IF lnNumCampo = 0
						ERROR 'No se encontr� el campo [' + laProps(I) + '] en la estructura del archivo ' + DBF("TABLABIN")
					ENDIF

					lcFieldType	= laFieldTypes(lnNumCampo,2)
					lnFieldLen	= laFieldTypes(lnNumCampo,3)
					lnFieldDec	= laFieldTypes(lnNumCampo,4)
					luValor		= EVALUATE('loReg.' + laProps(I))

					DO CASE
					CASE INLIST(lcFieldType, 'B')	&& Double
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldPrec) ) )

					CASE INLIST(lcFieldType, 'F', 'N', 'Y')	&& Float, Numeric, Currency
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldLen, lnFieldDec) ) )

					CASE INLIST(lcFieldType, 'W', 'G', 'M', 'Q', 'V', 'C')	&& Blob, General, Memo, Varbinary, Varchar, Character
						ADDPROPERTY( loReg, laProps(I), luValor )

					OTHERWISE	&& Dem�s tipos
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldLen) ) )

					ENDCASE

				ENDFOR

				INSERT INTO TABLABIN FROM NAME loReg
				loReg	= NULL
			ENDFOR

			USE IN (SELECT("TABLABIN"))

			IF toFoxbin2prg.l_Recompile
				IF THIS.c_Type = 'FRX'
					COMPILE REPORT (THIS.c_OutputFile)
				ELSE
					COMPILE LABEL (THIS.c_OutputFile)
				ENDIF
			ENDIF


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toReport
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(?@ IN    ) Sin uso
		* tnBloquesExclusion		(?@ IN    ) Sin uso
		* toReport					(?@    OUT) Objeto con toda la informaci�n del reporte analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, seg�n corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llFoxBin2Prg_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toReport			= NULL
				toReport			= CREATEOBJECT('CL_REPORT')

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vac�a o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toReport, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE .analizarBloque_Reportes( toReport, @lcLine, @taCodeLines, @I, tnCodeLines )

						ENDCASE
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_CDATA_inline
		*------------------------------------------------------
		*-- Analiza el bloque <picture>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines, toReg, tcPropName

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcValue, loEx AS EXCEPTION

			IF LEFT(tcLine, 1 + LEN(tcPropName) + 1 + 9) == '<' + tcPropName + '>' + C_DATA_I
				llBloqueEncontrado	= .T.

				IF C_DATA_F $ tcLine
					lcValue	= STREXTRACT( tcLine, C_DATA_I, C_DATA_F )
					ADDPROPERTY( toReg, tcPropName, lcValue )
					EXIT
				ENDIF

				*-- Tomo la primera parte del valor
				lcValue	= STREXTRACT( tcLine, C_DATA_I )

				*-- Recorro las fracciones del valor
				FOR I = I + 1 TO tnCodeLines
					tcLine	= taCodeLines(I)

					IF C_DATA_F $ tcLine	&& Fin del valor
						lcValue	= lcValue + CR_LF + STREXTRACT( tcLine, '', C_DATA_F )
						ADDPROPERTY( toReg, tcPropName, lcValue )
						EXIT

					ELSE	&& Otra fracci�n del valor
						lcValue	= lcValue + CR_LF + tcLine
					ENDIF
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'PropName=[' + TRANSFORM(tcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_platform
		*------------------------------------------------------
		*-- Analiza el bloque <platform=>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines, toReg

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lnPos, lnPos2, lcValue, lnLenPropName, laProps(1) ;
				, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count

			IF LOWER( LEFT(tcLine, 10) ) == 'platform="'
				llBloqueEncontrado	= .T.
				lnLastPos			= 1
				tcLine				= ' ' + tcLine

				FOR X = 1 TO AMEMBERS( laProps, toReg, 0 )
					laProps(X)	= ' ' + laProps(X)
					lnPos		= AT( LOWER(laProps(X)) + '="', tcLine )

					IF lnPos > 0
						lnLenPropName	= LEN(laProps(X))
						lnPos2			= AT( '"', SUBSTR( tcLine, lnPos + lnLenPropName + 2 ) )
						lcValue			= SUBSTR( tcLine, lnPos + lnLenPropName + 2, lnPos2 - 1 )

						ADDPROPERTY( toReg, laProps(X), lcValue )
					ENDIF
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_Reportes
		*------------------------------------------------------
		*-- Analiza el bloque <reportes>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loReg

			IF LEFT( tcLine, LEN(C_TAG_REPORTE) + 1 ) == '<' + C_TAG_REPORTE + ''
				llBloqueEncontrado	= .T.
				loReg	= THIS.emptyRecord()

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						lcComment	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, LEN(C_TAG_REPORTE_F) ) == C_TAG_REPORTE_F
							I = I + 1
							EXIT

						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
							LOOP	&& Saltear comentarios

						CASE .analizarBloque_platform( toReport, @tcLine, @taCodeLines, @I, @tnCodeLines, @loReg )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'picture' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'tag' )
							*-- ARREGLO ALGUNOS VALORES CAMBIADOS AL TEXTUALIZAR
							DO CASE
							CASE loReg.ObjType == "1"
								loReg.TAG	= THIS.decode_SpecialCodes_1_31( loReg.TAG )
							CASE loReg.ObjType == "25"
								loReg.TAG	= SUBSTR(loReg.TAG,3)	&& Quito el ENTER agregado antes
							OTHERWISE
								loReg.TAG	= THIS.decode_SpecialCodes_1_31( loReg.TAG )
							ENDCASE

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'tag2' )
							*-- ARREGLO ALGUNOS VALORES CAMBIADOS AL TEXTUALIZAR
							loReg.TAG2	= STRCONV( loReg.TAG2,14 )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'penred' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'style' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'expr' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'user' )

						ENDCASE

					ENDFOR
				ENDWITH && THIS

				I = I - 1
				toReport.ADD( loReg )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


ENDDEFINE	&& CLASS c_conversor_prg_a_frx AS c_conversor_prg_a_bin


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_dbf AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_dbf OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_table" display="analizarBloque_TABLE"/>] ;
		+ [<memberdata name="analizarbloque_fields" display="analizarBloque_FIELDS"/>] ;
		+ [<memberdata name="analizarbloque_indexes" display="analizarBloque_INDEXES"/>] ;
		+ [</VFPData>]


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toTable					(@!    OUT) Objeto generado de clase CL_TABLE con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toTable, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toTable, @toEx )

		#IF .F.
			LOCAL toTable AS CL_DBF_TABLE OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo del reporte
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toTable )

			THIS.escribirArchivoBin( @toTable )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toTable
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toTable AS CL_DBF_TABLE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lnCodError, loEx AS EXCEPTION
			LOCAL loField AS CL_DBF_FIELD OF 'FOXBIN2PRG.PRG'
			LOCAL loIndex AS CL_DBF_INDEX OF 'FOXBIN2PRG.PRG'
			LOCAL lcCreateTable, lcLongDec, lcFieldDef, lcIndex, ldLastUpdate, lcTempDBC
			LOCAL loDBFUtils AS CL_DBF_UTILS OF 'FOXBIN2PRG.PRG'

			loDBFUtils			= CREATEOBJECT('CL_DBF_UTILS')

			STORE 0 TO lnCodError
			STORE '' TO lcIndex, lcFieldDef

			ERASE (FORCEEXT(THIS.c_OutputFile, 'DBF'))
			ERASE (FORCEEXT(THIS.c_OutputFile, 'FPT'))
			ERASE (FORCEEXT(THIS.c_OutputFile, 'CDX'))

			IF EMPTY(toTable._Database)
				lcCreateTable	= 'CREATE TABLE "' + THIS.c_OutputFile + '" FREE CodePage=' + toTable._CodePage + ' ('
			ELSE
				lcTempDBC	= FORCEPATH( '_FB2P', JUSTPATH(THIS.c_OutputFile) )
				CREATE DATABASE ( lcTempDBC )
				lcCreateTable	= 'CREATE TABLE "' + THIS.c_OutputFile + '" CodePage=' + toTable._CodePage + ' ('
			ENDIF

			*-- Conformo los campos
			FOR EACH loField IN toTable._Fields FOXOBJECT
				lcLongDec		= ''

				*-- Nombre, Tipo
				lcFieldDef	= lcFieldDef + ', ' + loField._Name + ' ' + loField._Type

				*-- Longitud
				IF INLIST( loField._Type, 'C', 'N', 'F', 'Q', 'V' )
					lcLongDec	= lcLongDec + '(' + loField._Width
				ENDIF

				*-- Decimales
				IF INLIST( loField._Type, 'B', 'N', 'F' ) AND loField._Decimals > '0'
					IF EMPTY(lcLongDec)
						lcLongDec	= lcLongDec + '('
					ELSE
						lcLongDec	= lcLongDec + ','
					ENDIF
					lcLongDec	= lcLongDec + loField._Decimals
				ENDIF

				IF NOT EMPTY(lcLongDec)
					lcLongDec	= lcLongDec + ')'
				ENDIF

				lcFieldDef	= lcFieldDef + lcLongDec

				*-- Null
				lcFieldDef	= lcFieldDef + IIF( loField._Null = '.T.', ' NULL', ' NOT NULL' )

				*-- NoCPTran
				IF loField._NoCPTran = '.T.'
					lcFieldDef	= lcFieldDef + ' NOCPTRANS'
				ENDIF

				*-- AutoInc
				IF loField._AutoInc_NextVal <> '0'
					lcFieldDef	= lcFieldDef + ' AUTOINC NEXTVAL ' + loField._AutoInc_NextVal + ' STEP ' + loField._AutoInc_Step
				ENDIF

				loField			= NULL
			ENDFOR

			lcCreateTable	= lcCreateTable + SUBSTR(lcFieldDef,3) + ')'
			&lcCreateTable.

			*-- Regenero los �ndices
			FOR EACH loIndex IN toTable._Indexes FOXOBJECT
				lcIndex	= 'INDEX ON ' + loIndex._Key + ' TAG ' + loIndex._TagName

				IF loIndex._TagType = 'BINARY'
					lcIndex	= lcIndex + ' BINARY'
				ELSE
					lcIndex	= lcIndex + ' COLLATE "' + loIndex._Collate + '"'

					IF NOT EMPTY(loIndex._Filter)
						lcIndex	= lcIndex + ' FOR ' + loIndex._Filter
					ENDIF

					lcIndex	= lcIndex + ' ' + loIndex._Order

					IF NOT INLIST(loIndex._TagType, 'NORMAL', 'REGULAR')
						*-- Si es PRIMARY lo cambio a CANDIDATE y luego lo recodifico
						lcIndex	= lcIndex + ' ' + STRTRAN( loIndex._TagType, 'PRIMARY', 'CANDIDATE' )
					ENDIF
				ENDIF

				&lcIndex.
			ENDFOR


			USE IN (SELECT(JUSTSTEM(THIS.c_OutputFile)))

			*-- La actualizaci�n de la fecha sirve para evitar diferencias al regenerar el DBF
			ldLastUpdate	= EVALUATE( '{^' + toTable._LastUpdate + '}' )
			loDBFUtils.write_DBC_BackLink( THIS.c_OutputFile, toTable._Database, ldLastUpdate )


		CATCH TO loEx
			lnCodError		= loEx.ERRORNO
			loEx.USERVALUE	= 'lcIndex="' + TRANSFORM(lcIndex) + '"' + CR_LF ;
				+ 'lcFieldDef="' + TRANSFORM(lcFieldDef) + '"' + CR_LF ;
				+ 'lcCreateTable="' + TRANSFORM(lcCreateTable) + '"'

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT(JUSTSTEM(THIS.c_OutputFile)))

			IF NOT EMPTY(lcTempDBC)
				CLOSE DATABASES
				ERASE (FORCEEXT(lcTempDBC,'DBC'))
				ERASE (FORCEEXT(lcTempDBC,'DCT'))
				ERASE (FORCEEXT(lcTempDBC,'DCX'))
			ENDIF

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(?@ IN    ) Sin uso
		* tnBloquesExclusion		(?@ IN    ) Sin uso
		* toTable					(?@    OUT) Objeto con toda la informaci�n de la tabla analizada
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toTable
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toTable AS CL_DBF_TABLE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llFoxBin2Prg_Completed, llBloqueTable_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toTable		= NULL
				toTable		= CREATEOBJECT('CL_DBF_TABLE')

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vac�a o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toTable, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llBloqueTable_Completed AND toTable.analizarBloque( @lcLine, @taCodeLines, @I, tnCodeLines )
							llBloqueTable_Completed	= .T.

						ENDCASE
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


ENDDEFINE	&& CLASS c_conversor_prg_a_dbf AS c_conversor_prg_a_bin


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_dbc AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_dbc OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_tables" display="analizarBloque_TABLES"/>] ;
		+ [<memberdata name="analizarbloque_views" display="analizarBloque_VIEWS"/>] ;
		+ [<memberdata name="analizarbloque_tablefields" display="analizarBloque_TABLEFIELDS"/>] ;
		+ [<memberdata name="analizarbloque_viewfields" display="analizarBloque_VIEWFIELDS"/>] ;
		+ [<memberdata name="analizarbloque_relations" display="analizarBloque_RELATIONS"/>] ;
		+ [<memberdata name="analizarbloque_connections" display="analizarBloque_CONNECTIONS"/>] ;
		+ [<memberdata name="analizarbloque_database" display="analizarBloque_DATABASE"/>] ;
		+ [</VFPData>]


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toDatabase				(@!    OUT) Objeto generado de clase CL_DBC con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toDatabase, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toDatabase, @toEx )

		#IF .F.
			LOCAL toDatabase AS CL_DBC OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo la tabla
			*THIS.createTable()

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo del reporte
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toDatabase )

			THIS.escribirArchivoBin( @toDatabase, toFoxbin2prg )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toDatabase, toFoxbin2prg
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toDatabase AS CL_DBC OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, lcCreateTable, lcLongDec, lcFieldDef, lcIndex, ldLastUpdate
			lnCodError	= 0
			STORE '' TO lcIndex, lcFieldDef

			toDatabase.updateDBC( THIS.c_OutputFile )

			IF toFoxbin2prg.l_Recompile
				COMPILE DATABASE (THIS.c_OutputFile)
			ENDIF


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(?@ IN    ) Sin uso
		* tnBloquesExclusion		(?@ IN    ) Sin uso
		* toDatabase				(?@    OUT) Objeto con toda la informaci�n de la base de datos analizada
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, seg�n corresponda.
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toDatabase
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toDatabase AS CL_DBC OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llFoxBin2Prg_Completed, llBloqueDatabase_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toDatabase		= NULL
				toDatabase		= CREATEOBJECT('CL_DBC')

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vac�a o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toDatabase, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llBloqueDatabase_Completed AND toDatabase.analizarBloque( @lcLine, @taCodeLines, @I, tnCodeLines )
							llBloqueDatabase_Completed	= .T.

						ENDCASE
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


ENDDEFINE	&& CLASS c_conversor_prg_a_dbc AS c_conversor_prg_a_bin


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_mnx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="c_menulocation" display="c_MenuLocation"/>] ;
		+ [<memberdata name="n_menutype" display="n_MenuType"/>] ;
		+ [</VFPData>]


	n_MenuType		= 0
	c_MenuLocation	= ''

	*******************************************************************************************************************
	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toMenu					(@!    OUT) Objeto generado de clase CL_DBC con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toMenu, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toMenu, @toEx )

		#IF .F.
			LOCAL toMenu AS CL_MENU OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			toFoxbin2prg.doBackup( .F., .T., '', '', '' )

			*-- Creo la tabla
			THIS.createMenu()

			*-- Identifico el inicio/fin de bloque, definici�n, cabecera y cuerpo del reporte
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toMenu )

			THIS.escribirArchivoBin( @toMenu )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY

		RETURN lnCodError
	ENDPROC


	PROCEDURE identificarBloquesDeCodigo
		*--------------------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las l�neas del c�digo donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de l�neas de c�digo
		* taBloquesExclusion		(?@ IN    ) Sin uso
		* tnBloquesExclusion		(?@ IN    ) Sin uso
		* toMenu					(?@    OUT) Objeto con toda la informaci�n del men� analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, seg�n corresponda.
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toMenu
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toMenu AS CL_MENU OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llFoxBin2Prg_Completed, llBloqueMenu_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toMenu		= NULL
				toMenu		= CREATEOBJECT('CL_MENU')

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vac�a o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toMenu, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llBloqueMenu_Completed AND toMenu.analizarBloque( @lcLine, @taCodeLines, @I, tnCodeLines, THIS )
							llBloqueMenu_Completed	= .T.

						ENDCASE
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	PROCEDURE escribirArchivoBin
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toMenu					(@!    OUT) Objeto generado de clase CL_DBC con la informaci�n leida del texto
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toMenu

		#IF .F.
			LOCAL toMenu AS CL_MENU OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, lcCreateTable, lcLongDec, lcFieldDef, lcIndex, ldLastUpdate
			lnCodError	= 0
			STORE '' TO lcIndex, lcFieldDef

			toMenu.updateMENU( THIS )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT(JUSTSTEM(THIS.c_OutputFile)))

		ENDTRY

		RETURN lnCodError
	ENDPROC


ENDDEFINE	&& CLASS c_conversor_prg_a_mnx AS c_conversor_prg_a_bin


*******************************************************************************************************************
DEFINE CLASS c_conversor_bin_a_prg AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_bin_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="convertir" display="Convertir"/>] ;
		+ [<memberdata name="exception2str" display="Exception2Str"/>] ;
		+ [<memberdata name="get_add_object_methods" display="get_ADD_OBJECT_METHODS"/>] ;
		+ [<memberdata name="get_nombresobjetosolepublic" display="get_NombresObjetosOLEPublic"/>] ;
		+ [<memberdata name="get_propsfrom_protected" display="get_PropsFrom_PROTECTED"/>] ;
		+ [<memberdata name="get_propsandcommentsfrom_reserved3" display="get_PropsAndCommentsFrom_RESERVED3"/>] ;
		+ [<memberdata name="get_propsandvaluesfrom_properties" display="get_PropsAndValuesFrom_PROPERTIES"/>] ;
		+ [<memberdata name="indentarmemo" display="IndentarMemo"/>] ;
		+ [<memberdata name="memoinoneline" display="MemoInOneLine"/>] ;
		+ [<memberdata name="normalizarasignacion" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="set_multilinememowithaddobjectproperties" display="set_MultilineMemoWithAddObjectProperties"/>] ;
		+ [<memberdata name="sortmethod" display="SortMethod"/>] ;
		+ [<memberdata name="write_add_objects_withproperties" display="write_ADD_OBJECTS_WithProperties"/>] ;
		+ [<memberdata name="write_all_object_methods" display="write_ALL_OBJECT_METHODS"/>] ;
		+ [<memberdata name="write_cabecera_reporte" display="write_CABECERA_REPORTE"/>] ;
		+ [<memberdata name="write_class_methods" display="write_CLASS_METHODS"/>] ;
		+ [<memberdata name="write_class_properties" display="write_CLASS_PROPERTIES"/>] ;
		+ [<memberdata name="write_dataenvironment_reporte" display="write_DATAENVIRONMENT_REPORTE"/>] ;
		+ [<memberdata name="write_dbc_header" display="write_DBC_HEADER"/>] ;
		+ [<memberdata name="write_dbc_connections" display="write_DBC_CONNECTIONS"/>] ;
		+ [<memberdata name="write_dbc_tables" display="write_DBC_TABLES"/>] ;
		+ [<memberdata name="write_dbc_table_fields" display="write_DBC_TABLE_FIELDS"/>] ;
		+ [<memberdata name="write_dbc_table_indexes" display="write_DBC_TABLE_INDEXES"/>] ;
		+ [<memberdata name="write_dbc_views" display="write_DBC_VIEWS"/>] ;
		+ [<memberdata name="write_dbc_view_fields" display="write_DBC_VIEW_FIELDS"/>] ;
		+ [<memberdata name="write_dbc_view_indexes" display="write_DBC_VIEW_INDEXES"/>] ;
		+ [<memberdata name="write_dbc_relations" display="write_DBC_RELATIONS"/>] ;
		+ [<memberdata name="write_dbf_header" display="write_DBF_HEADER"/>] ;
		+ [<memberdata name="write_dbf_fields" display="write_DBF_FIELDS"/>] ;
		+ [<memberdata name="write_dbf_indexes" display="write_DBF_INDEXES"/>] ;
		+ [<memberdata name="write_detalle_reporte" display="write_DETALLE_REPORTE"/>] ;
		+ [<memberdata name="write_defined_pam" display="write_DEFINED_PAM"/>] ;
		+ [<memberdata name="write_define_class" display="write_DEFINE_CLASS"/>] ;
		+ [<memberdata name="write_define_class_comments" display="write_Define_Class_COMMENTS"/>] ;
		+ [<memberdata name="write_definicionobjetosole" display="write_DefinicionObjetosOLE"/>] ;
		+ [<memberdata name="write_enddefine_sicorresponde" display="write_ENDDEFINE_SiCorresponde"/>] ;
		+ [<memberdata name="write_hidden_properties" display="write_HIDDEN_Properties"/>] ;
		+ [<memberdata name="write_include" display="write_INCLUDE"/>] ;
		+ [<memberdata name="write_metadata" display="write_METADATA"/>] ;
		+ [<memberdata name="write_protected_properties" display="write_PROTECTED_Properties"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase correspondiente con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_ADD_OBJECT_METHODS
		LPARAMETERS toRegObj, toRegClass, tcMethods, taMethods, taCode, tnMethodCount

		TRY
			THIS.SortMethod( toRegObj.METHODS, @taMethods, @taCode, '', @tnMethodCount )

			*-- Ubico los m�todos protegidos y les cambio la definici�n.
			*-- Los m�todos se deben generar con la ruta completa, porque si no es imposible saber a que objeto corresponden,
			*-- o si son de la clase.
			IF tnMethodCount > 0 THEN
				FOR I = 1 TO tnMethodCount
					IF EMPTY(toRegObj.PARENT)
						tcMethodName	= toRegObj.OBJNAME + '.' + taMethods(I,1)
					ELSE
						DO CASE
						CASE '.' $ toRegObj.PARENT
							tcMethodName	= SUBSTR(toRegObj.PARENT, AT('.', toRegObj.PARENT) + 1) + '.' + toRegObj.OBJNAME + '.' + taMethods(I,1)

						CASE LEFT(toRegObj.PARENT + '.', LEN( toRegClass.OBJNAME + '.' ) ) == toRegClass.OBJNAME + '.'
							tcMethodName	= toRegObj.OBJNAME + '.' + taMethods(I,1)

						OTHERWISE
							tcMethodName	= toRegObj.PARENT + '.' + toRegObj.OBJNAME + '.' + taMethods(I,1)

						ENDCASE
					ENDIF

					*-- Genero el m�todo SIN indentar, ya que se hace luego
					*tcMethods2	= tcMethods
					*TEXT TO tcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					*	<<'PROCEDURE'>> <<tcMethodName>>
					*	<<THIS.IndentarMemo( taCode(taMethods(I,2)) )>>
					*	<<'ENDPROC'>>
					*ENDTEXT
					*-- Sustituyo el TEXT/ENDTEXT aqu� porque a veces quita espacios de la derecha, y eso es peligroso
					tcMethods	= tcMethods + CR_LF + 'PROCEDURE ' + tcMethodName
					tcMethods	= tcMethods + CR_LF + THIS.IndentarMemo( taCode(taMethods(I,2)) )
					tcMethods	= tcMethods + CR_LF + 'ENDPROC'
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_NombresObjetosOLEPublic
		LPARAMETERS ta_NombresObjsOle
		*-- Obtengo los objetos "OLEPublic"
		SELECT PADR(OBJNAME,100) OBJNAME ;
			FROM TABLABIN ;
			WHERE TABLABIN.PLATFORM = "COMMENT" AND TABLABIN.RESERVED2 == "OLEPublic" ;
			ORDER BY 1 ;
			INTO ARRAY ta_NombresObjsOle
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsAndCommentsFrom_RESERVED3
		*-- Sirve para el memo RESERVED3
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tlSort					(v? IN    ) Indica si se deben ordenar alfab�ticamente los nombres
		* taPropsAndComments		(@!    OUT) Array con las propiedades y comentarios
		* tnPropsAndComments_Count	(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tlSort, taPropsAndComments, tnPropsAndComments_Count, tcSortedMemo
		EXTERNAL ARRAY taPropsAndComments

		TRY
			LOCAL laLines(1), I, lnPos, loEx AS EXCEPTION
			tcSortedMemo	= ''
			tnPropsAndComments_Count	= ALINES(laLines, tcMemo, 1+4)

			IF tnPropsAndComments_Count <= 1 AND EMPTY(laLines)
				tnPropsAndComments_Count	= 0
				EXIT
			ENDIF

			DIMENSION taPropsAndComments(tnPropsAndComments_Count,2)

			FOR I = 1 TO tnPropsAndComments_Count
				lnPos			= AT(' ', laLines(I))	&& Un espacio separa la propiedad de su comentario (si tiene)

				IF lnPos = 0
					taPropsAndComments(I,1)	= laLines(I)
					taPropsAndComments(I,2)	= ''
				ELSE
					taPropsAndComments(I,1)	= LEFT( laLines(I), lnPos - 1 )
					taPropsAndComments(I,2)	= SUBSTR( laLines(I), lnPos + 1 )
				ENDIF
			ENDFOR

			IF tlSort AND THIS.l_PropSort_Enabled
				ASORT( taPropsAndComments, 1, -1, 0, 1 )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsAndValuesFrom_PROPERTIES
		*-- Sirve para el memo PROPERTIES
		*---------------------------------------------------------------------------------------------------
		* KNOWLEDGE BASE:
		* 29/11/2013	FDBOZZO		En un pageframe, si las props.nativas del mismo no est�n antes que las de
		*							los objetos contenidos, causa un error. Se deben ordenar primero las
		*							props.nativas (sin punto) y luego las de los objetos (con punto)
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tnSort					(v? IN    ) Indica si se deben ordenar alfab�ticamente los objetos y props (1), o no (0)
		* taPropsAndValues			(@!    OUT) Array con las propiedades y comentarios
		* tnPropsAndValues_Count	(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tnSort, taPropsAndValues, tnPropsAndValues_Count, tcSortedMemo
		EXTERNAL ARRAY taPropsAndValues
		TRY
			LOCAL laItems(1), I, X, lnLenAcum, lnPosEQ, lcPropName, lnLenVal, lcValue, lcMethods
			tcSortedMemo			= ''
			tnPropsAndValues_Count	= 0

			IF NOT EMPTY(m.tcMemo)
				lnItemCount = ALINES(laItems, m.tcMemo, 0, CR_LF)	&& Espec�ficamente CR+LF para que no reconozca los CR o LF por separado
				X	= 0

				IF lnItemCount <= 1 AND EMPTY(laItems)
					lnItemCount	= 0
					EXIT
				ENDIF


				*-- 1) OBTENCI�N Y SEPARACI�N DE PROPIEDADES Y VALORES
				*-- Crear un array con los valores especiales que pueden estar repartidos entre varias lineas
				FOR I = 1 TO m.lnItemCount
					IF EMPTY( laItems(I) )
						LOOP
					ENDIF

					X	= X + 1
					DIMENSION taPropsAndValues(X,2)

					IF C_MPROPHEADER $ laItems(I)
						*-- Solo entrar� por aqu� cuando se eval�e una propiedad de PROPERTIES con un valor especial (largo)
						lnLenAcum	= 0
						lnPosEQ		= AT( '=', laItems(I) )
						lcPropName	= LEFT( laItems(I), lnPosEQ - 2 )
						lnLenVal	= INT( VAL( SUBSTR( laItems(I), lnPosEQ + 2 + 517, 8) ) )
						lcValue		= SUBSTR( laItems(I), lnPosEQ + 2 + 517 + 8 )

						IF LEN( lcValue ) < lnLenVal
							*-- Como el valor es multi-l�nea, debo agregarle los CR_LF que le quit� el ALINES()
							FOR I = I + 1 TO m.lnItemCount
								lcValue	= lcValue + CR_LF + laItems(I)

								IF LEN( lcValue ) >= lnLenVal
									EXIT
								ENDIF
							ENDFOR

							lcValue	= C_FB2P_VALUE_I + CR_LF + lcValue + CR_LF + C_FB2P_VALUE_F
						ELSE
							lcValue	= C_FB2P_VALUE_I + lcValue + C_FB2P_VALUE_F
						ENDIF

						*-- Es un valor especial, por lo que se encapsula en un marcador especial
						taPropsAndValues(X,1)	= lcPropName
						taPropsAndValues(X,2)	= THIS.normalizarValorPropiedad( lcPropName, lcValue, '' )

					ELSE
						*-- Propiedad normal
						*-- SI HACE FALTA QUE LOS M�TODOS EST�N AL FINAL, DESCOMENTAR ESTO (Y EL DE M�S ABAJO)
						*IF LEFT(laItems(I), 1) == '*'	&& Only Reserved3 have this
						*	LOOP
						*ENDIF

						lnPosEQ					= AT( '=', laItems(I) )
						taPropsAndValues(X,1)	= LEFT( laItems(I), lnPosEQ - 2 )
						taPropsAndValues(X,2)	=  THIS.normalizarValorPropiedad( taPropsAndValues(X,1), LTRIM( SUBSTR( laItems(I), lnPosEQ + 2 ) ), '' )
					ENDIF
				ENDFOR


				tnPropsAndValues_Count	= X
				lcMethods	= ''


				*-- 2) SORT
				THIS.sortPropsAndValues( @taPropsAndValues, tnPropsAndValues_Count, tnSort )


				*-- Agregar propiedades primero
				FOR I = 1 TO m.tnPropsAndValues_Count
					*-- SI HACE FALTA QUE LOS M�TODOS EST�N AL FINAL, DESCOMENTAR ESTO (Y EL DE M�S ARRIBA)
					*IF LEFT(taPropsAndValues(I,1), 1) == '*'	&& Only Reserved3 have this
					*	lcMethods	= m.lcMethods + m.taPropsAndValues(I,1) + ' = ' + m.taPropsAndValues(I,2) + CR_LF
					*	LOOP
					*ENDIF

					tcSortedMemo	= m.tcSortedMemo + m.taPropsAndValues(I,1) + ' = ' + m.taPropsAndValues(I,2) + CR_LF
				ENDFOR

				*-- Agregar m�todos al final
				tcSortedMemo	= m.tcSortedMemo + m.lcMethods

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsFrom_PROTECTED
		*-- Sirve para el memo PROTECTED
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tlSort					(v? IN    ) Indica si se deben ordenar alfab�ticamente los nombres
		* taProtected				(@!    OUT) Array con las propiedades y comentarios
		* tnProtected_Count			(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tlSort, taProtected, tnProtected_Count, tcSortedMemo
		EXTERNAL ARRAY taProtected

		tcSortedMemo		= ''
		tnProtected_Count	= ALINES(taProtected, tcMemo, 1+4)

		IF tnProtected_Count <= 1 AND EMPTY(taProtected)
			tnProtected_Count	= 0
		ELSE
			IF tlSort AND THIS.l_PropSort_Enabled
				ASORT( taProtected, 1, -1, 0, 1 )
			ENDIF

			FOR I = 1 TO tnProtected_Count
				tcSortedMemo	= tcSortedMemo + taProtected(I) + CR_LF
			ENDFOR
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE IndentarMemo
		LPARAMETERS tcMethod, tcIndentation
		*-- INDENTA EL C�DIGO DE UN M�TODO DADO Y QUITA LA CABECERA DE M�TODO (PROCEDURE/ENDPROC) SI LA ENCUENTRA
		TRY
			LOCAL I, X, lcMethod, llProcedure, lnInicio, lnFin, laLineas(1)
			lcMethod		= ''
			llProcedure		= ( LEFT(tcMethod,10) == 'PROCEDURE ' ;
				OR LEFT(tcMethod,17) == 'HIDDEN PROCEDURE ' ;
				OR LEFT(tcMethod,20) == 'PROTECTED PROCEDURE ' )
			lnInicio		= 1
			lnFin			= ALINES(laLineas, tcMethod)
			IF VARTYPE(tcIndentation) # 'C'
				tcIndentation	= ''
			ENDIF

			*-- Quito las l�neas en blanco luego del final del ENDPROC
			X	= 0
			FOR I = lnFin TO 1 STEP -1
				IF NOT EMPTY(laLineas(I))	&& �ltima l�nea de c�digo
					IF LEFT( laLineas(I), 10 ) <> C_ENDPROC
						ERROR 'Procedimiento sin cerrar. La �ltima l�nea de c�digo debe ser ENDPROC. [' + laLineas(1) + ']'
					ENDIF
					EXIT
				ENDIF
				X	= X + 1
			ENDFOR

			IF X > 0
				lnFin	= lnFin - X
				DIMENSION laLineas(lnFin)
			ENDIF


			*-- Si encuentra la cabecera de un PROCEDURE, la saltea
			IF llProcedure
				lnInicio	= 2
				lnFin		= lnFin - 1
			ENDIF

			FOR I = lnInicio TO lnFin
				*-- TEXT/ENDTEXT aqu� da error 2044 de recursividad. No usar.
				lcMethod	= lcMethod + CR_LF + tcIndentation + laLineas(I)
			ENDFOR

			lcMethod	= SUBSTR(lcMethod,3)	&& Quito el primer ENTER (CR+LF)

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcMethod
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE MemoInOneLine( tcMethod )
		TRY
			LOCAL lcLine, I
			lcLine	= ''

			IF NOT EMPTY(tcMethod)
				FOR I = 1 TO ALINES(laLines, m.tcMethod, 0)
					lcLine	= lcLine + ', ' + laLines(I)
				ENDFOR

				lcLine	= SUBSTR(lcLine, 3)
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE set_MultilineMemoWithAddObjectProperties
		LPARAMETERS taPropsAndValues, tnPropCount, tcLeftIndentation, tlNormalizeLine
		EXTERNAL ARRAY taPropsAndValues

		TRY
			LOCAL lcLine, I, lcComentarios, laLines(1), lcFinDeLinea_Coma_PuntoComa_CR
			lcLine			= ''
			lcFinDeLinea	= ', ;' + CR_LF

			IF tnPropCount > 0
				IF VARTYPE(tcLeftIndentation) # 'C'
					tcLeftIndentation	= ''
				ENDIF

				FOR I = 1 TO tnPropCount
					lcLine			= lcLine + tcLeftIndentation + taPropsAndValues(I,1) + ' = ' + taPropsAndValues(I,2) + lcFinDeLinea
				ENDFOR

				*-- Quito el ", ;<CRLF>" final
				lcLine	= tcLeftIndentation + SUBSTR(lcLine, 1 + LEN(tcLeftIndentation), LEN(lcLine) - LEN(tcLeftIndentation) - LEN(lcFinDeLinea))
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE SortMethod
		LPARAMETERS tcMethod, taMethods, taCode, tcSorted, tnMethodCount
		*-- 29/10/2013	Fernando D. Bozzo
		*-- Se tiene en cuenta la posibilidad de que haya un PROC/ENDPROC dentro de un TEXT/ENDTEXT
		*-- cuando es usado en un generador de c�digo o similar.
		EXTERNAL ARRAY taMethods, taCode

		*-- ESTRUCTURA DE LOS ARRAYS CREADOS:
		*-- taMethods[1,3]
		*--		Nombre M�todo
		*--		Posici�n Original
		*--		Tipo (HIDDEN/PROTECTED/NORMAL)
		*-- taCode[1]
		*--		Bloque de c�digo del m�todo en su posici�n original
		TRY
			LOCAL lnLineCount, laLine(1), I, lnTextNodes, tcSorted
			LOCAL loEx AS EXCEPTION
			DIMENSION taMethods(1,3)
			STORE '' TO taMethods, m.tcSorted, taCode
			tnMethodCount	= 0

			IF NOT EMPTY(m.tcMethod) AND LEFT(m.tcMethod,9) == "ENDPROC"+CHR(13)+CHR(10)
				tcMethod	= SUBSTR(m.tcMethod,10)
			ENDIF

			IF NOT EMPTY(m.tcMethod)
				DIMENSION laLine(1), taMethods(1,3)
				STORE '' TO laLine, taMethods, taCode
				STORE 0 TO tnMethodCount, lnTextNodes
				lnLineCount	= ALINES(laLine, m.tcMethod)	&& NO aplicar nung�n formato ni limpieza, que es el C�DIGO FUENTE

				*-- Delete beginning empty lines before first "PROCEDURE", that is the first not empty line.
				FOR I = 1 TO lnLineCount
					IF NOT EMPTY(laLine(I))
						IF I > 1
							FOR X = I-1 TO 1 STEP -1
								ADEL(laLine, X)
							ENDFOR
							lnLineCount	= lnLineCount - I + 1
							DIMENSION laLine(lnLineCount)
						ENDIF
						EXIT
					ENDIF
				ENDFOR

				*-- Delete ending empty lines after last "ENDPROC", that is the last not empty line.
				FOR I = lnLineCount TO 1 STEP -1
					IF EMPTY(laLine(I))
						ADEL(laLine, I)
					ELSE
						IF I < lnLineCount
							lnLineCount	= I
							DIMENSION laLine(lnLineCount)
						ENDIF
						EXIT
					ENDIF
				ENDFOR

				*-- Analyze and count line methods, get method names and consolidate block code
				FOR I = 1 TO lnLineCount
					DO CASE
					CASE LEFT(laLine(I), 4) == C_TEXT
						lnTextNodes	= lnTextNodes + 1
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE LEFT(laLine(I), 7) == C_ENDTEXT
						lnTextNodes	= lnTextNodes - 1
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 10) == 'PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 11) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= ''
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 17) == 'HIDDEN PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 18) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= 'HIDDEN '
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 20) == 'PROTECTED PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 21) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= 'PROTECTED '
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 7) == 'ENDPROC'
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE tnMethodCount = 0	&& Skip empty lines before methods begin

					OTHERWISE && Method Code
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					ENDCASE
				ENDFOR

				*-- Alphabetical ordering of methods
				IF THIS.l_MethodSort_Enabled
					ASORT(taMethods,1,-1,0,1)
				ENDIF

				FOR I = 1 TO tnMethodCount
					m.tcSorted	= m.tcSorted + taCode(taMethods(I,2))
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC	&& SordMethod


	*******************************************************************************************************************
	PROCEDURE write_ADD_OBJECTS_WithProperties
		LPARAMETERS toRegObj

		#IF .F.
			LOCAL toRegObj AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcMemo, laPropsAndValues(1,2), lnPropsAndValues_Count

			*-- Defino los objetos a cargar
			THIS.get_PropsAndValuesFrom_PROPERTIES( toRegObj.PROPERTIES, 1, @laPropsAndValues, @lnPropsAndValues_Count, @lcMemo )
			*lcMemo	= THIS.set_MultilineMemoWithAddObjectProperties( lcMemo, C_TAB + C_TAB, .T. )
			lcMemo	= THIS.set_MultilineMemoWithAddObjectProperties( @laPropsAndValues, @lnPropsAndValues_Count, C_TAB + C_TAB, .T. )

			IF '.' $ toRegObj.PARENT
				*-- Este caso: clase.objeto.objeto ==> se quita clase
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	ADD OBJECT '<<SUBSTR(toRegObj.Parent, AT('.', toRegObj.Parent)+1)>>.<<toRegObj.objName>>' AS <<ALLTRIM(toRegObj.Class)>> <<>>
				ENDTEXT
			ELSE
				*-- Este caso: objeto
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	ADD OBJECT '<<toRegObj.objName>>' AS <<ALLTRIM(toRegObj.Class)>> <<>>
				ENDTEXT
			ENDIF

			IF NOT EMPTY(lcMemo)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<C_WITH>> ;
					<<lcMemo>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB + C_TAB>><<C_END_OBJECT_I>> <<>>
			ENDTEXT

			IF NOT EMPTY(toRegObj.CLASSLOC)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					ClassLib="<<toRegObj.ClassLoc>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
				BaseClass="<<toRegObj.Baseclass>>" UniqueID="<<toRegObj.Uniqueid>>"
				Timestamp="<<THIS.getTimeStamp(toRegObj.Timestamp)>>" ZOrder="<<TRANSFORM(toRegObj._ZOrder)>>" <<>>
			ENDTEXT

			*-- Agrego metainformaci�n para objetos OLE
			IF toRegObj.BASECLASS == 'olecontrol'
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					OLEObject="<<STREXTRACT(toRegObj.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" CheckSum="<<SYS(2007, toRegObj.ole, 0, 1)>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_END_OBJECT_F>>
				<<>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ALL_OBJECT_METHODS
		LPARAMETERS tcMethods

		*-- Finalmente, todos los m�todos los ordeno y escribo juntos
		LOCAL laMethods(1), laCode(1), lnMethodCount, I, lcMethods, lcMethods2

		IF NOT EMPTY(tcMethods)
			STORE '' TO lcMethods, lcMethods2
			DIMENSION laMethods(1,3)
			THIS.SortMethod( @tcMethods, @laMethods, @laCode, '', @lnMethodCount )

			FOR I = 1 TO lnMethodCount
				*-- Genero los m�todos indentados
				*TEXT TO lcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*	<<>>	<<laMethods(I,3)>>PROCEDURE <<laMethods(I,1)>>
				*	<<THIS.IndentarMemo( laCode(laMethods(I,2)), CHR(9) + CHR(9) )>>
				*	<<>>	ENDPROC

				*ENDTEXT
				*-- Sustituyo el TEXT/ENDTEXT aqu� porque a veces quita espacios de la derecha, y eso es peligroso
				lcMethods	= lcMethods + CR_LF + C_TAB + laMethods(I,3) + C_PROCEDURE + ' ' + laMethods(I,1)
				lcMethods	= lcMethods + CR_LF + THIS.IndentarMemo( laCode(laMethods(I,2)), CHR(9) + CHR(9) )
				lcMethods	= lcMethods + CR_LF + C_TAB + C_ENDPROC
				lcMethods	= lcMethods + CR_LF
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcMethods
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_METHODS
		LPARAMETERS tnMethodCount, taMethods, taCode, taProtected, taPropsAndComments
		*-- DEFINIR M�TODOS DE LA CLASE
		*-- Ubico los m�todos protegidos y les cambio la definici�n
		EXTERNAL ARRAY taMethods, taCode, taProtected, taPropsAndComments

		TRY
			LOCAL lcMethod, lnProtectedItem, lnCommentRow, lcProcDef, lcMethods, lcMethods2
			STORE '' TO lcMethod, lcProcDef, lcMethods, lcMethods2

			IF tnMethodCount > 0 THEN
				FOR I = 1 TO tnMethodCount
					lcMethod			= CHRTRAN( taMethods(I,1), '^', '' )
					lnProtectedItem		= ASCAN( taProtected, taMethods(I,1), 1, 0, 0, 0)
					lnCommentRow		= ASCAN( taPropsAndComments, '*' + lcMethod, 1, 0, 1, 8)

					DO CASE
					CASE lnProtectedItem = 0
						*-- M�todo com�n
						lcProcDef	= 'PROCEDURE'

					CASE taProtected(lnProtectedItem) == taMethods(I,1)
						*-- M�todo protegido
						lcProcDef	= 'PROTECTED PROCEDURE'

					CASE taProtected(lnProtectedItem) == taMethods(I,1) + '^'
						*-- M�todo oculto
						lcProcDef	= 'HIDDEN PROCEDURE'

					ENDCASE

					*-- Nombre del m�todo
					TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	<<lcProcDef>> <<taMethods(I,1)>>
					ENDTEXT

					*-- Comentarios del m�todo (si tiene)
					IF lnCommentRow > 0 AND NOT EMPTY(taPropsAndComments(lnCommentRow,2))
						TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
							<<>>		&& <<taPropsAndComments(lnCommentRow,2)>>
						ENDTEXT
					ENDIF

					*-- C�digo del m�todo
					*TEXT TO lcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					*	<<THIS.IndentarMemo( taCode(taMethods(I,2)), CHR(9) + CHR(9) )>>
					*	<<>>	ENDPROC

					*ENDTEXT
					*-- Sustituyo el TEXT/ENDTEXT aqu� porque a veces quita espacios de la derecha, y eso es peligroso
					lcMethods	= lcMethods + CR_LF + THIS.IndentarMemo( taCode(taMethods(I,2)), C_TAB + C_TAB )
					lcMethods	= lcMethods + CR_LF + C_TAB + 'ENDPROC'
					lcMethods	= lcMethods + CR_LF
				ENDFOR

				*TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*	<<lcMethods>>
				*ENDTEXT
				C_FB2PRG_CODE	= C_FB2PRG_CODE + C_TAB + lcMethods &&+ CR_LF

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_PROPERTIES
		LPARAMETERS toRegClass, taPropsAndValues, taPropsAndComments, taProtected

		EXTERNAL ARRAY taPropsAndValues, taPropsAndComments

		TRY
			LOCAL lnPropsAndValues_Count, lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd, lnPropsAndComments_Count, I ;
				, lcPropName, lnProtectedItem, lcComentarios

			WITH THIS
				*-- DEFINIR PROPIEDADES ( HIDDEN, PROTECTED, *DEFINED_PAM )
				DIMENSION taProtected(1)
				STORE '' TO lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd
				THIS.get_PropsAndValuesFrom_PROPERTIES( toRegClass.PROPERTIES, 1, @taPropsAndValues, @lnPropsAndValues_Count, '' )
				THIS.get_PropsAndCommentsFrom_RESERVED3( toRegClass.RESERVED3, .T., @taPropsAndComments, @lnPropsAndComments_Count, '' )
				THIS.get_PropsFrom_PROTECTED( toRegClass.PROTECTED, .T., @taProtected, 0, '' )

				IF lnPropsAndValues_Count > 0 THEN
					*-- Recorro las propiedades (campo Properties) para ir conformando
					*-- las definiciones HIDDEN y PROTECTED
					FOR I = 1 TO lnPropsAndValues_Count
						IF EMPTY(taPropsAndValues(I,1))
							LOOP
						ENDIF

						lnProtectedItem	= ASCAN(taProtected, taPropsAndValues(I,1), 1, 0, 0, 0)

						DO CASE
						CASE lnProtectedItem = 0
							*-- Propiedad com�n

						CASE taProtected(lnProtectedItem) == taPropsAndValues(I,1)
							*-- Propiedad protegida
							lcProtectedProp	= lcProtectedProp + ',' + taPropsAndValues(I,1)

						CASE taProtected(lnProtectedItem) == taPropsAndValues(I,1) + '^'
							*-- Propiedad oculta
							lcHiddenProp	= lcHiddenProp + ',' + taPropsAndValues(I,1)

						ENDCASE
					ENDFOR

					THIS.write_DEFINED_PAM( @taPropsAndComments, lnPropsAndComments_Count )

					THIS.write_HIDDEN_Properties( @lcHiddenProp )

					THIS.write_PROTECTED_Properties( @lcProtectedProp )

					*-- Escribo las propiedades de la clase y sus comentarios (los comentarios aqu� son redundantes)
					FOR I = 1 TO ALEN(taPropsAndValues, 1)
						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
							<<>>	<<taPropsAndValues(I,1)>> = <<taPropsAndValues(I,2)>>
						ENDTEXT

						lnComment	= ASCAN( taPropsAndComments, taPropsAndValues(I,1), 1, 0, 1, 8)

						IF lnComment > 0 AND NOT EMPTY(taPropsAndComments(lnComment,2))
							TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
								<<>>		&& <<taPropsAndComments(lnComment,2)>>
							ENDTEXT
						ENDIF
					ENDFOR

					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>
					ENDTEXT
				ENDIF
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINED_PAM
		*-- Escribo propiedades DEFINED (Reserved3) en este formato:

		*<DefinedPropArrayMethod>
		*m: *metodovacio_con_comentarios		&& Este m�todo no tiene c�digo, pero tiene comentarios. A ver que pasa!
		*m: *mimetodo		&& Mi metodo
		*p: prop1		&& Mi prop 1
		*p: prop_especial_cr		&&
		*a: ^array_1_d[1,0]		&& Array 1 dimensi�n (1)
		*a: ^array_2_d[1,2]		&& Array una dimension (1,2)
		*p: _memberdata		&& XML Metadata for customizable properties
		*</DefinedPropArrayMethod>

		LPARAMETERS taPropsAndComments, tnPropsAndComments_Count

		IF tnPropsAndComments_Count > 0
			LOCAL I, lcPropsMethodsDefd
			lcPropsMethodsDefd	= ''

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_DEFINED_PAM_I>>
			ENDTEXT

			FOR I = 1 TO tnPropsAndComments_Count
				IF EMPTY(taPropsAndComments(I,1))
					LOOP
				ENDIF

				lcType	= LEFT( taPropsAndComments(I,1), 1 )
				lcType	= ICASE( lcType == '*', 'm' ;
					, lcType == '^', 'a' ;
					, 'p' )

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>		*<<lcType>>: <<taPropsAndComments(I,1)>>
				ENDTEXT

				IF NOT EMPTY(taPropsAndComments(I,2))
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<>>		<<'&'>><<'&'>> <<taPropsAndComments(I,2)>>
					ENDTEXT
				ENDIF
			ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_DEFINED_PAM_F>>
			ENDTEXT

		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINE_CLASS
		LPARAMETERS ta_NombresObjsOle, toRegClass

		LOCAL lcOF_Classlib, llOleObject
		lcOF_Classlib	= ''
		llOleObject		= ( ASCAN( ta_NombresObjsOle, toRegClass.OBJNAME, 1, 0, 1, 8) > 0 )

		IF NOT EMPTY(toRegClass.CLASSLOC)
			lcOF_Classlib	= 'OF "' + ALLTRIM(toRegClass.CLASSLOC) + '" '
		ENDIF

		*-- DEFINICI�N DE LA CLASE ( DEFINE CLASS 'className' AS 'classType' [OF 'classLib'] [OLEPUBLIC] )
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<'DEFINE CLASS'>> <<ALLTRIM(toRegClass.ObjName)>> AS <<ALLTRIM(toRegClass.Class)>> <<lcOF_Classlib + IIF(llOleObject, 'OLEPUBLIC', '')>>
		ENDTEXT

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINE_CLASS_COMMENTS
		LPARAMETERS toRegClass
		*-- Comentario de la clase
		IF NOT EMPTY(toRegClass.RESERVED7) THEN
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<>>		<<'&'+'&'>> <<toRegClass.Reserved7>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ENDDEFINE_SiCorresponde
		LPARAMETERS tnLastClass
		IF tnLastClass = 1
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<'ENDDEFINE'>>
				<<>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_INCLUDE
		LPARAMETERS toReg
		*-- #INCLUDE
		IF NOT EMPTY(toReg.RESERVED8) THEN
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	#INCLUDE "<<toReg.Reserved8>>"
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_METADATA
		LPARAMETERS toRegClass

		*-- Agrego Metadatos de la clase (Baseclass, Timestamp, Scale, Uniqueid)
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<>>
		ENDTEXT

		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+8
			<<>>	<<C_METADATA_I>>
			Baseclass="<<toRegClass.Baseclass>>"
			Timestamp="<<THIS.getTimeStamp(toRegClass.Timestamp)>>"
			Scale="<<toRegClass.Reserved6>>"
			Uniqueid="<<EVL(toRegClass.Uniqueid,SYS(2015))>>"
		ENDTEXT

		IF NOT EMPTY(toRegClass.OLE2)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				OLEObject="<<STREXTRACT(toRegClass.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" CheckSum="<<SYS(2007, toRegClass.ole, 0, 1)>>" <<>>
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED5)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				ProjectClassIcon="<<toRegClass.Reserved5>>"
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED4)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				ClassIcon="<<toRegClass.Reserved4>>"
			ENDTEXT
		ENDIF

		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
			<<C_METADATA_F>>
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_HIDDEN_Properties
		*-- Escribo la definici�n HIDDEN de propiedades
		LPARAMETERS tcHiddenProp

		IF NOT EMPTY(tcHiddenProp)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	HIDDEN <<SUBSTR(tcHiddenProp,2)>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_PROTECTED_Properties
		*-- Escribo la definici�n PROTECTED de propiedades
		LPARAMETERS tcProtectedProp

		IF NOT EMPTY(tcProtectedProp)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	PROTECTED <<SUBSTR(tcProtectedProp,2)>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CABECERA_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx AS EXCEPTION
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" >
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<picture><![CDATA[<<toReg.picture>>]]>
				<<>>	<tag><![CDATA[<<THIS.encode_SpecialCodes_1_31( toReg.tag )>>]]>
				<<>>	<tag2><![CDATA[<<STRCONV( toReg.tag2,13 )>>]]>
				<<>>	<penred><![CDATA[<<toReg.penred>>]]>
				<<>>	<style><![CDATA[<<toReg.style>>]]>
				<<>>	<expr><![CDATA[<<toReg.expr>>]]>
				<<>>	<user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DETALLE_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx AS EXCEPTION
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<picture><![CDATA[<<toReg.picture>>]]>
				<<>>	<tag><![CDATA[<<THIS.encode_SpecialCodes_1_31( toReg.tag )>>]]>
				<<>>	<tag2><![CDATA[<<STRCONV( toReg.tag2,13 )>>]]>
				<<>>	<penred><![CDATA[<<toReg.penred>>]]>
				<<>>	<style><![CDATA[<<toReg.style>>]]>
				<<>>	<expr><![CDATA[<<toReg.expr>>]]>
				<<>>	<user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DATAENVIRONMENT_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx AS EXCEPTION
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" <<>>
			ENDTEXT

			* NOTA: En el DataEnvironment el TAG2 es el TAG compilado, que se recompila con COMPILE REPORT <nombre>
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<picture><![CDATA[<<toReg.picture>>]]>
				<<>>	<tag><![CDATA[<<CR_LF>><<toReg.tag>>]]>
				<<>>	<tag2><![CDATA[]]>
				<<>>	<penred><![CDATA[<<toReg.penred>>]]>
				<<>>	<style><![CDATA[<<toReg.style>>]]>
				<<>>	<expr><![CDATA[<<toReg.expr>>]]>
				<<>>	<user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DefinicionObjetosOLE
		*-- Crea la definici�n del tag *< OLE: /> con la informaci�n de todos los objetos OLE
		LOCAL lnOLECount, lcOLEChecksum, llOleExistente, loReg

		TRY
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ
			lnOLECount	= 0

			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" AND BASECLASS = 'olecontrol'
				SCATTER MEMO NAME loReg
				lcOLEChecksum	= SYS(2007, loReg.OLE, 0, 1)
				llOleExistente	= .F.

				IF lnOLECount > 0 AND ASCAN(laOLE, lcOLEChecksum, 1, 0, 0, 0) > 0
					llOleExistente	= .T.
				ENDIF

				lnOLECount	= lnOLECount + 1
				DIMENSION laOLE( lnOLECount )
				laOLE( lnOLECount )	= lcOLEChecksum

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
				ENDTEXT

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
					<<C_OLE_I>>
					Nombre="<<IIF(EMPTY(loReg.Parent),'',loReg.Parent+'.') + loReg.objName>>"
					Parent="<<loReg.Parent>>"
					ObjName="<<loReg.objname>>"
					OLEObject="<<STREXTRACT(loReg.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>"
					Checksum="<<lcOLEChecksum>>" <<>>
				ENDTEXT

				IF NOT llOleExistente
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						Value="<<STRCONV(loReg.ole,13)>>" <<>>
					ENDTEXT
				ENDIF

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<C_OLE_F>>
				ENDTEXT

			ENDSCAN

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE FixOle2Fields
		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* OLE2 contains the physical name of the OCX or DLL when a record refers to an ActiveX
		* control. On different developer machines these controls can be located in different
		* folders without affecting the code.
		*
		* When a control is stored outside the project directory, we assume that every developer
		* is responsible for installing and registering the control. Therefore we only leave
		* the file name which should be fixed. It's also sufficient for VFP to locate an OCX
		* file when the control is not registered and the OCX file is stored in the current
		* directory or the application path.
		*--------------------------------------------------------------------------------------
		* Project directory for comparision purposes
		*--------------------------------------------------------------------------------------
		LOCAL lcProjDir
		lcProjDir = UPPER(ALLTRIM(THIS.cHomeDir))
		IF RIGHT(m.lcProjDir,1) == "\"
			lcProjDir = LEFT(m.lcProjDir, LEN(m.lcProjDir)-1)
		ENDIF

		*--------------------------------------------------------------------------------------
		* Check all OLE2 fields
		*--------------------------------------------------------------------------------------
		LOCAL lcOcx
		SCAN FOR NOT EMPTY(OLE2)
			lcOcx = STREXTRACT (OLE2, "OLEObject = ", CHR(13), 1, 1+2)
			IF THIS.OcxOutsideProjDir (m.lcOcx, m.lcProjDir)
				THIS.TruncateOle2 (m.lcOcx)
			ENDIF
		ENDSCAN

	ENDPROC


	*******************************************************************************************************************
	FUNCTION OcxOutsideProjDir
		LPARAMETERS tcOcx, tcProjDir
		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* Returns .T. when the OCX control resides outside the project directory

		LOCAL lcOcxDir, llOutside
		lcOcxDir = UPPER (JUSTPATH (m.tcOcx))
		IF LEFT(m.lcOcxDir, LEN(m.tcProjDir)) == m.tcProjDir
			llOutside = .F.
		ELSE
			llOutside = .T.
		ENDIF

		RETURN m.llOutside


		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* Cambios de un campo OLE2 exclusivamente en el nombre del archivo
	PROCEDURE TruncateOle2 (tcOcx)
		REPLACE OLE2 WITH STRTRAN ( ;
			OLE2 ;
			,"OLEObject = " + m.tcOcx ;
			,"OLEObject = " + JUSTFNAME(m.tcOcx) ;
			)
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_vcx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_vcx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_MODULO con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1), lnLen ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS _TABLAORIG
			SELECT * FROM _TABLAORIG INTO CURSOR TABLABIN
			USE IN (SELECT("_TABLAORIG"))

			INDEX ON PADR(LOWER(PLATFORM + IIF(EMPTY(PARENT),'',ALLTRIM(PARENT)+'.')+OBJNAME),240) TAG PARENT_OBJ OF TABLABIN ADDITIVE
			SET ORDER TO 0 IN TABLABIN

			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			THIS.get_NombresObjetosOLEPublic( @la_NombresObjsOle )

			THIS.write_DefinicionObjetosOLE()

			*-- Escribo los m�todos ordenados
			lnLastClass		= 0

			*----------------------------------------------
			*-- RECORRO LAS CLASES
			*----------------------------------------------
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ

			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" AND TABLABIN.RESERVED1=="Class"
				SCATTER MEMO NAME loRegClass
				lcObjName	= ALLTRIM(loRegClass.OBJNAME)

				THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

				THIS.write_DEFINE_CLASS( @la_NombresObjsOle, @loRegClass )

				THIS.write_DEFINE_CLASS_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laPropsAndValues, @laPropsAndComments, @laProtected )


				*-------------------------------------------------------------------------------
				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA EXPORTAR SU DEFINICI�N
				*-------------------------------------------------------------------------------
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST WHILE TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName
					SCATTER MEMO NAME loRegObj
					ADDPROPERTY( loRegObj, '_ZOrder', RECNO()*100 )		&& Para permitir insertar objetos manualmente entre medias al integrar cambios
					THIS.write_ADD_OBJECTS_WithProperties( @loRegObj )
				ENDSCAN

				GOTO RECORD (lnRecno)


				*-- OBTENGO LOS M�TODOS DE LA CLASE PARA POSTERIOR TRATAMIENTO
				DIMENSION laMethods(1,3)
				lcMethods	= ''
				THIS.SortMethod( loRegClass.METHODS, @laMethods, @laCode, '', @lnMethodCount )

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsAndComments )

				lnLastClass		= 1
				lcMethods		= ''

				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA OBTENER SUS M�TODOS
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST ;
						FOR TABLABIN.PLATFORM = "WINDOWS" AND NOT TABLABIN.RESERVED1=="Class" ;
						WHILE ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

					SCATTER MEMO NAME loRegObj
					THIS.get_ADD_OBJECT_METHODS( @loRegObj, @loRegClass, @lcMethods )
				ENDSCAN

				THIS.write_ALL_OBJECT_METHODS( @lcMethods )

				GOTO RECORD (lnRecno)
			ENDSCAN

			THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

			*-- Genero el VC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_scx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_scx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_MODULO con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toModulo, @toEx )

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1), lnLen ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS _TABLAORIG
			SELECT * FROM _TABLAORIG INTO CURSOR TABLABIN
			USE IN (SELECT("_TABLAORIG"))

			INDEX ON PADR(LOWER(PLATFORM + IIF(EMPTY(PARENT),'',ALLTRIM(PARENT)+'.')+OBJNAME),240) TAG PARENT_OBJ OF TABLABIN ADDITIVE
			SET ORDER TO 0 IN TABLABIN

			*toModulo	= NULL
			*toModulo	= CREATEOBJECT('CL_MODULO')

			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			THIS.get_NombresObjetosOLEPublic( @la_NombresObjsOle )

			THIS.write_DefinicionObjetosOLE()

			*-- Escribo los m�todos ordenados
			lnLastObj		= 0
			lnLastClass		= 0

			*----------------------------------------------
			*-- RECORRO LAS CLASES
			*----------------------------------------------
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ
			GOTO RECORD 1

			SCATTER FIELDS RESERVED8 MEMO NAME loRegClass

			IF NOT EMPTY(loRegClass.RESERVED8) THEN
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					#INCLUDE "<<loRegClass.Reserved8>>"
					<<>>
				ENDTEXT
			ENDIF


			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" ;
					AND (EMPTY(TABLABIN.PARENT) ;
					AND (TABLABIN.BASECLASS == 'dataenvironment' OR TABLABIN.BASECLASS == 'form' OR TABLABIN.BASECLASS == 'formset' ) )

				*loRegClass	= NULL
				SCATTER MEMO NAME loRegClass
				*toModulo.add_Class( loRegClass )
				lcObjName	= ALLTRIM(loRegClass.OBJNAME)

				THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

				THIS.write_DEFINE_CLASS( @la_NombresObjsOle, @loRegClass )

				THIS.write_DEFINE_CLASS_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laPropsAndValues, @laPropsAndComments, @laProtected )


				*-------------------------------------------------------------------------------
				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA EXPORTAR SU DEFINICI�N
				*-------------------------------------------------------------------------------
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST WHILE TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName
					SCATTER MEMO NAME loRegObj
					ADDPROPERTY( loRegObj, '_ZOrder', RECNO()*100 )		&& Para permitir insertar objetos manualmente entre medias al integrar cambios
					THIS.write_ADD_OBJECTS_WithProperties( @loRegObj )
				ENDSCAN

				GOTO RECORD (lnRecno)


				*-- OBTENGO LOS M�TODOS DE LA CLASE PARA POSTERIOR TRATAMIENTO
				DIMENSION laMethods(1,3)
				lcMethods	= ''
				THIS.SortMethod( loRegClass.METHODS, @laMethods, @laCode, '', @lnMethodCount )

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsAndComments )

				lnLastClass		= 1
				lcMethods		= ''

				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA OBTENER SUS M�TODOS
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST ;
						FOR TABLABIN.PLATFORM = "WINDOWS" ;
						AND NOT (EMPTY(TABLABIN.PARENT) ;
						AND (TABLABIN.BASECLASS == 'dataenvironment' OR TABLABIN.BASECLASS == 'form' OR TABLABIN.BASECLASS == 'formset' ) ) ;
						WHILE ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

					SCATTER MEMO NAME loRegObj
					THIS.get_ADD_OBJECT_METHODS( @loRegObj, @loRegClass, @lcMethods )
				ENDSCAN

				THIS.write_ALL_OBJECT_METHODS( @lcMethods )

				GOTO RECORD (lnRecno)
			ENDSCAN

			THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

			*-- Genero el SC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			loRegObj	= NULL
			loRegClass	= NULL
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_pjx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_pjx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_PROJECT con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, lcStr, lnPos, lnLen, lnServerCount, loReg, lcDevInfo, lnLen ;
				, loEx AS EXCEPTION ;
				, loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG' ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			STORE NULL TO loProject, loReg, loServerHead, loServerData

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS _TABLAORIG
			SELECT * FROM _TABLAORIG INTO CURSOR TABLABIN
			USE IN (SELECT("_TABLAORIG"))

			loServerHead	= CREATEOBJECT('CL_PROJ_SRV_HEAD')


			*-- Obtengo los archivos del proyecto
			loProject		= CREATEOBJECT('CL_PROJECT')
			SCATTER MEMO NAME loReg
			loProject._HomeDir		= ['] + ALLTRIM( THIS.get_ValueFromNullTerminatedValue( loReg.HOMEDIR ) ) + [']

			loProject._ServerInfo	= loReg.RESERVED2
			loProject._Debug		= loReg.DEBUG
			loProject._Encrypted	= loReg.ENCRYPT
			lcDevInfo				= loReg.DEVINFO


			*--- Ubico el programa principal
			LOCATE FOR MAINPROG

			IF FOUND()
				loProject._MainProg	= LOWER( ALLTRIM( THIS.get_ValueFromNullTerminatedValue( NAME ) ) )
			ENDIF


			*-- Ubico el Project Hook
			LOCATE FOR TYPE == 'W'

			IF FOUND()
				loProject._ProjectHookLibrary	= LOWER( ALLTRIM( THIS.get_ValueFromNullTerminatedValue( NAME ) ) )
				loProject._ProjectHookClass	= LOWER( ALLTRIM( THIS.get_ValueFromNullTerminatedValue( RESERVED1 ) ) )
			ENDIF


			*-- Ubico el icono del proyecto
			LOCATE FOR TYPE == 'i'

			IF FOUND()
				loProject._Icon	= LOWER( ALLTRIM( THIS.get_ValueFromNullTerminatedValue( NAME ) ) )
			ENDIF


			*-- Escaneo el proyecto
			SCAN ALL FOR NOT INLIST(TYPE, 'H','W','i' )
				SCATTER FIELDS NAME,TYPE,EXCLUDE,COMMENTS,CPID,TIMESTAMP,ID,OBJREV MEMO NAME loReg
				loReg.NAME		= LOWER( ALLTRIM( THIS.get_ValueFromNullTerminatedValue( loReg.NAME ) ) )
				loReg.COMMENTS	= ALLTRIM( THIS.get_ValueFromNullTerminatedValue( loReg.COMMENTS ) )

				*-- TIP: Si el "Name" del objeto est� vac�o, lo salteo
				IF EMPTY(loReg.NAME)
					LOOP
				ENDIF

				TRY
					loProject.ADD( loReg, loReg.NAME )
				CATCH TO loEx WHEN loEx.ERRORNO = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
					*-- Saltear y no agregar el archivo duplicado / Bypass and not add the duplicated file
				ENDTRY
			ENDSCAN


			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()


			*-- Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				LPARAMETERS tcDir
				<<>>
				lcCurdir = SYS(5)+CURDIR()
				CD ( EVL( tcDir, JUSTPATH( SYS(16) ) ) )
				<<>>
			ENDTEXT


			*-- Informaci�n del programa
			loProject.parseDeviceInfo( lcDevInfo )
			C_FB2PRG_CODE	= C_FB2PRG_CODE + loProject.getFormattedDeviceInfoText() + CR_LF


			*-- Informaci�n de los Servidores definidos
			IF NOT EMPTY(loProject._ServerInfo)
				loServerHead.parseServerInfo( loProject._ServerInfo )
				C_FB2PRG_CODE	= C_FB2PRG_CODE + loServerHead.getFormattedServerText() + CR_LF
				loServerHead	= NULL
			ENDIF


			*-- Generaci�n del proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_BUILDPROJ_I>>
				<<>>*<.HomeDir = <<loProject._HomeDir>> />
				<<>>
				FOR EACH loProject IN _VFP.Projects FOXOBJECT
				<<>>	loProject.Close()
				ENDFOR
				<<>>
				STRTOFILE( '', '__newproject.f2b' )
				BUILD PROJECT <<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>> FROM '__newproject.f2b'
			ENDTEXT


			*-- Abro el proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				FOR EACH loProject IN _VFP.Projects FOXOBJECT
				<<>>	loProject.Close()
				ENDFOR
				<<>>
				MODIFY PROJECT '<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>' NOWAIT NOSHOW NOPROJECTHOOK
				<<>>
				loProject = _VFP.Projects('<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>')
				<<>>
				WITH loProject.FILES
			ENDTEXT


			*-- Definir archivos del proyecto y metadata: CPID, Timestamp, ID, etc.
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.ADD('<<loReg.NAME>>')
				ENDTEXT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
					<<>>		<<'&'>><<'&'>> <<C_FILE_META_I>>
					Type="<<loReg.TYPE>>"
					Cpid="<<INT( loReg.CPID )>>"
					Timestamp="<<INT( loReg.TIMESTAMP )>>"
					ID="<<INT( loReg.ID )>>"
					ObjRev="<<INT( loReg.OBJREV )>>"
					<<C_FILE_META_F>>
				ENDTEXT
			ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_BUILDPROJ_F>>
				<<>>
				<<>>	.ITEM('__newproject.f2b').Remove()
				<<>>
			ENDTEXT


			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_CMTS_I>>
			ENDTEXT


			*-- Agrego los comentarios
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF NOT EMPTY(loReg.COMMENTS)
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Description = '<<loReg.COMMENTS>>'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Exclusiones
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_CMTS_F>>
				<<>>
				<<>>	<<C_FILE_EXCL_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF loReg.EXCLUDE
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Exclude = .T.
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Tipos de archivos especiales
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_EXCL_F>>
				<<>>
				<<>>	<<C_FILE_TXT_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF INLIST( UPPER( JUSTEXT( loReg.NAME ) ), 'H','FPW' )
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Type = 'T'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- ProjectHook, Debug, Encrypt, Build y cierre
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_TXT_F>>
				<<C_ENDWITH>>
				<<>>
				<<C_WITH>> loProject
				<<>>	<<C_PROJPROPS_I>>
			ENDTEXT

			IF NOT EMPTY(loProject._MainProg)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.SetMain(lcCurdir + '<<loProject._MainProg>>')
				ENDTEXT
			ENDIF

			IF NOT EMPTY(loProject._Icon)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.Icon = lcCurdir + '<<loProject._Icon>>'
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	.Debug = <<loProject._Debug>>
				<<>>	.Encrypted = <<loProject._Encrypted>>
				<<>>	*<.CmntStyle = <<loProject._CmntStyle>> />
				<<>>	*<.NoLogo = <<loProject._NoLogo>> />
				<<>>	*<.SaveCode = <<loProject._SaveCode>> />
				<<>>	.ProjectHookLibrary = '<<loProject._ProjectHookLibrary>>'
				<<>>	.ProjectHookClass = '<<loProject._ProjectHookClass>>'
				<<>>	<<C_PROJPROPS_F>>
				<<C_ENDWITH>>
				<<>>
			ENDTEXT


			*-- Build y cierre
			*	_VFP.Projects('<<JUSTFNAME( THIS.c_inputFile )>>').FILES('__newproject.f2b').Remove()
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				_VFP.Projects('<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>').Close()
			ENDTEXT

			*-- Restauro Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*ERASE '__newproject.f2b'
				CD (lcCurdir)
				RETURN
			ENDTEXT


			*-- Genero el PJ2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			lnCodError	= toEx.ERRORNO

			DO CASE
			CASE lnCodError = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
				toEx.USERVALUE	= 'Archivo duplicado: ' + loReg.NAME
			ENDCASE

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


DEFINE CLASS c_conversor_pjm_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_pjm_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_PROJECT con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, lcStr, lnPos, lnLen, lnServerCount, loReg, lcDevInfo, lnLen ;
				, lcStrPJM, laLines(1), laProps(1) ;
				, loEx AS EXCEPTION ;
				, loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG' ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			STORE NULL TO loProject, loReg, loServerHead, loServerData
			lcStrPJM		= FILETOSTR( THIS.c_InputFile )
			loServerHead	= CREATEOBJECT('CL_PROJ_SRV_HEAD')


			*-- Obtengo los archivos del proyecto
			loProject		= CREATEOBJECT('CL_PROJECT')

			WITH loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
				*-- Proj.Info
				._CmntStyle				= STREXTRACT( lcStrPJM, 'CommentStyle=', CR_LF )
				._Debug					= STREXTRACT( lcStrPJM, 'Debug=', CR_LF )
				._Encrypted				= STREXTRACT( lcStrPJM, 'Encrypt=', CR_LF )
				._HomeDir				= ['] + LOWER( JUSTPATH( SYS(5)+CURDIR() ) ) + [']
				._ID					= ''
				._NoLogo				= STREXTRACT( lcStrPJM, 'NoLogo=', CR_LF )
				._ObjRev				= 0
				._ProjectHookClass		= ''
				._ProjectHookLibrary	= ''
				._SaveCode				= STREXTRACT( lcStrPJM, 'SaveCode=', CR_LF )
				._ServerHead			= NULL
				._ServerInfo			= 'ServerData'
				._SourceFile			= ''
				._TimeStamp				= 0
				._Version				= STREXTRACT( lcStrPJM, 'Version=', CR_LF )

				*-- Dev.info
				._Author				= STREXTRACT( lcStrPJM, 'Author=', CR_LF )
				._Company				= STREXTRACT( lcStrPJM, 'Company=', CR_LF )
				._Address				= STREXTRACT( lcStrPJM, 'Address=', CR_LF )
				._City					= STREXTRACT( lcStrPJM, 'City=', CR_LF )
				._State					= STREXTRACT( lcStrPJM, 'State=', CR_LF )
				._PostalCode			= STREXTRACT( lcStrPJM, 'Zip=', CR_LF )
				._Country				= STREXTRACT( lcStrPJM, 'Country=', CR_LF )

				._Comments				= STREXTRACT( lcStrPJM, 'Comments=', CR_LF )
				._CompanyName			= STREXTRACT( lcStrPJM, 'CompanyName=', CR_LF )
				._FileDescription		= STREXTRACT( lcStrPJM, 'FileDescription=', CR_LF )
				._LegalCopyright		= STREXTRACT( lcStrPJM, 'LegalCopyright=', CR_LF )
				._LegalTrademark		= STREXTRACT( lcStrPJM, 'LegalTrademarks=', CR_LF )
				._ProductName			= STREXTRACT( lcStrPJM, 'ProductName=', CR_LF )
				._MajorVer				= STREXTRACT( lcStrPJM, 'Major=', CR_LF )
				._MinorVer				= STREXTRACT( lcStrPJM, 'Minor=', CR_LF )
				._Revision				= STREXTRACT( lcStrPJM, 'Revision=', CR_LF )
				._AutoIncrement			= IIF( STREXTRACT( lcStrPJM, 'AutoIncrement=', CR_LF ) = '.T.', '1', '0' )
			ENDWITH

			FOR I = 1 TO ALINES( laLines, STREXTRACT( lcStrPJM, '[OLEServers]', '[OLEServersEnd]' ), 4 )
				ALINES( laProps, laLines(I), 1, ',' )

				IF I = 1
					WITH loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'
						._LibraryName	= laProps(1)
						._InternalName	= laProps(2)
						._ProjectName	= laProps(3)
						._TypeLibDesc	= laProps(4)
						._ServerType	= PADL(laProps(5),4)
						._TypeLib		= laProps(6)
					ENDWITH

				ELSE
					loServerData = CREATEOBJECT("CL_PROJ_SRV_DATA")

					WITH loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
						._HelpContextID	= laProps(4)
						._ServerName	= laProps(3)
						._Description	= laProps(5)
						._HelpFile		= laProps(6)
						._ServerClass	= laProps(1)
						._ClassLibrary	= laProps(2)
						._Instancing	= laProps(7)
						._CLSID			= laProps(8)
						._Interface		= laProps(9)
					ENDWITH

					loServerHead.add_Server( loServerData )
					loServerData	= NULL
				ENDIF
			ENDFOR



			*-- Escaneo el proyecto
			FOR I = 1 TO ALINES( laLines, STREXTRACT( lcStrPJM, '[ProjectFiles]', '[EOF]' ), 4 )
				ALINES( laProps, laLines(I) + ',', 1, ',' )
				loReg	= CREATEOBJECT("EMPTY")
				ADDPROPERTY( loReg, 'ID', VAL( laProps(1) ) )
				ADDPROPERTY( loReg, 'TYPE', laProps(2) )
				ADDPROPERTY( loReg, 'NAME', laProps(3) )
				ADDPROPERTY( loReg, 'EXCLUDE', EVALUATE( laProps(4) ) )
				ADDPROPERTY( loReg, 'MAINPROG', laProps(5) )
				ADDPROPERTY( loReg, 'CPID', VAL( laProps(6) ) )
				ADDPROPERTY( loReg, 'COMMENTS', laProps(9) )
				ADDPROPERTY( loReg, 'TIMESTAMP', 0 )
				ADDPROPERTY( loReg, 'OBJREV', 0 )

				*-- TIP: Si el "Name" del objeto est� vac�o, lo salteo
				IF EMPTY(loReg.NAME)
					LOOP
				ENDIF

				TRY
					DO CASE
					CASE loReg.MAINPROG = '.T.'
						loProject._MainProg	= loReg.NAME
						loProject.ADD( loReg, loReg.NAME )
					CASE loReg.TYPE == 'W'
						*
					CASE loReg.TYPE == 'i'
						loProject._Icon	= loReg.NAME
					OTHERWISE
						loProject.ADD( loReg, loReg.NAME )
					ENDCASE

				CATCH TO loEx WHEN loEx.ERRORNO = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
					*-- Saltear y no agregar el archivo duplicado / Bypass and not add the duplicated file
				FINALLY
					loReg	= NULL
				ENDTRY
			ENDFOR


			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()


			*-- Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				LPARAMETERS tcDir
				<<>>
				lcCurdir = SYS(5)+CURDIR()
				CD ( EVL( tcDir, JUSTPATH( SYS(16) ) ) )
				<<>>
			ENDTEXT


			*-- Informaci�n del programa
			C_FB2PRG_CODE	= C_FB2PRG_CODE + loProject.getFormattedDeviceInfoText() + CR_LF


			*-- Informaci�n de los Servidores definidos
			IF NOT EMPTY(loProject._ServerInfo)
				C_FB2PRG_CODE	= C_FB2PRG_CODE + loServerHead.getFormattedServerText() + CR_LF
				loServerHead	= NULL
			ENDIF


			*-- Generaci�n del proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_BUILDPROJ_I>>
				<<>>*<.HomeDir = <<loProject._HomeDir>> />
				<<>>
				FOR EACH loProject IN _VFP.Projects FOXOBJECT
				<<>>	loProject.Close()
				ENDFOR
				<<>>
				STRTOFILE( '', '__newproject.f2b' )
				BUILD PROJECT <<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>> FROM '__newproject.f2b'
			ENDTEXT


			*-- Abro el proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				FOR EACH loProject IN _VFP.Projects FOXOBJECT
				<<>>	loProject.Close()
				ENDFOR
				<<>>
				MODIFY PROJECT '<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>' NOWAIT NOSHOW NOPROJECTHOOK
				<<>>
				loProject = _VFP.Projects('<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>')
				<<>>
				WITH loProject.FILES
			ENDTEXT


			*-- Definir archivos del proyecto y metadata: CPID, Timestamp, ID, etc.
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.ADD('<<loReg.NAME>>')
				ENDTEXT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
					<<>>		<<'&'>><<'&'>> <<C_FILE_META_I>>
					Type="<<loReg.TYPE>>"
					Cpid="<<INT( loReg.CPID )>>"
					Timestamp="<<INT( loReg.TIMESTAMP )>>"
					ID="<<INT( loReg.ID )>>"
					ObjRev="<<INT( loReg.OBJREV )>>"
					<<C_FILE_META_F>>
				ENDTEXT
			ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_BUILDPROJ_F>>
				<<>>
				<<>>	.ITEM('__newproject.f2b').Remove()
				<<>>
			ENDTEXT


			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_CMTS_I>>
			ENDTEXT


			*-- Agrego los comentarios
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF NOT EMPTY(loReg.COMMENTS)
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Description = '<<loReg.COMMENTS>>'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Exclusiones
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_CMTS_F>>
				<<>>
				<<>>	<<C_FILE_EXCL_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF loReg.EXCLUDE
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Exclude = .T.
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Tipos de archivos especiales
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_EXCL_F>>
				<<>>
				<<>>	<<C_FILE_TXT_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF INLIST( UPPER( JUSTEXT( loReg.NAME ) ), 'H','FPW' )
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	.ITEM(lcCurdir + '<<loReg.NAME>>').Type = 'T'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- ProjectHook, Debug, Encrypt, Build y cierre
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FILE_TXT_F>>
				<<C_ENDWITH>>
				<<>>
				<<C_WITH>> loProject
				<<>>	<<C_PROJPROPS_I>>
			ENDTEXT

			IF NOT EMPTY(loProject._MainProg)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.SetMain(lcCurdir + '<<loProject._MainProg>>')
				ENDTEXT
			ENDIF

			IF NOT EMPTY(loProject._Icon)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	.Icon = lcCurdir + '<<loProject._Icon>>'
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	.Debug = <<loProject._Debug>>
				<<>>	.Encrypted = <<loProject._Encrypted>>
				<<>>	*<.CmntStyle = <<loProject._CmntStyle>> />
				<<>>	*<.NoLogo = <<loProject._NoLogo>> />
				<<>>	*<.SaveCode = <<loProject._SaveCode>> />
				<<>>	.ProjectHookLibrary = '<<loProject._ProjectHookLibrary>>'
				<<>>	.ProjectHookClass = '<<loProject._ProjectHookClass>>'
				<<>>	<<C_PROJPROPS_F>>
				<<C_ENDWITH>>
				<<>>
			ENDTEXT


			*-- Build y cierre
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				_VFP.Projects('<<JUSTFNAME( EVL( THIS.c_OriginalFileName, THIS.c_InputFile ) )>>').Close()
			ENDTEXT

			*-- Restauro Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*ERASE '__newproject.f2b'
				CD (lcCurdir)
				RETURN
			ENDTEXT


			*-- Genero el PJ2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			lnCodError	= toEx.ERRORNO

			DO CASE
			CASE lnCodError = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
				toEx.USERVALUE	= 'Archivo duplicado: ' + loReg.NAME
			ENDCASE

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			*USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_frx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_frx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" display="Convertir"/>] ;
	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Objeto generado de clase CL_PROJECT con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loRegCab, loRegDataEnv, loRegCur, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1), lnLen ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegObj, loRegCab, loRegDataEnv, loRegCur

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS _TABLAORIG
			SELECT * FROM _TABLAORIG INTO CURSOR TABLABIN_0
			USE IN (SELECT("_TABLAORIG"))

			*-- Header
			LOCATE FOR ObjType = 1
			IF FOUND()
				SCATTER MEMO NAME loRegCab
			ENDIF

			*-- Dataenvironment
			LOCATE FOR ObjType = 25
			IF FOUND()
				SCATTER MEMO NAME loRegDataEnv
			ENDIF

			*-- Cursor1 (�puede haber m�s de 1 cursor?)
			LOCATE FOR ObjType = 26
			IF FOUND()
				SCATTER MEMO NAME loRegCur
			ENDIF

			IF THIS.l_ReportSort_Enabled
				*-- ORDENADO
				SELECT * FROM TABLABIN_0 ;
					WHERE ObjType NOT IN (1,25,26) ;
					ORDER BY vpos,hpos ;
					INTO CURSOR TABLABIN READWRITE
			ELSE
				*-- SIN ORDENAR (S�lo para poder comparar con el original)
				SELECT * FROM TABLABIN_0 ;
					WHERE ObjType NOT IN (1,25,26) ;
					INTO CURSOR TABLABIN
			ENDIF

			loRegObj	= NULL
			USE IN (SELECT("TABLABIN_0"))


			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			*-- Recorro los registros y genero el texto
			IF VARTYPE(loRegCab) = "O"
				THIS.write_CABECERA_REPORTE( @loRegCab )
			ENDIF

			SELECT TABLABIN
			GOTO TOP

			SCAN ALL
				SCATTER MEMO NAME loRegObj
				THIS.write_DETALLE_REPORTE( @loRegObj )
			ENDSCAN

			IF VARTYPE(loRegDataEnv) = "O"
				THIS.write_DATAENVIRONMENT_REPORTE( @loRegDataEnv )
			ENDIF

			IF VARTYPE(loRegCur) = "O"
				THIS.write_DETALLE_REPORTE( @loRegCur )
			ENDIF


			*-- Genero el FR2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
			USE IN (SELECT("TABLABIN_0"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_dbf_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_dbf_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toModulo					(@!    OUT) Contenido del texto generado
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toModulo, toEx AS EXCEPTION, toFoxbin2prg
		#IF .F.
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, laDatabases(1), lnDatabases_Count, laDatabases2(1), lnLen, lc_FileTypeDesc ;
				, ln_HexFileType, ll_FileHasCDX, ll_FileHasMemo, ll_FileIsDBC, lc_DBC_Name
			LOCAL loTable AS CL_DBF_TABLE OF 'FOXBIN2PRG.PRG'
			LOCAL loDBFUtils AS CL_DBF_UTILS OF 'FOXBIN2PRG.PRG'

			STORE 0 TO lnCodError
			loDBFUtils			= CREATEOBJECT('CL_DBF_UTILS')

			loDBFUtils.getDBFmetadata( THIS.c_InputFile, @ln_HexFileType, @ll_FileHasCDX, @ll_FileHasMemo, @ll_FileIsDBC, @lc_DBC_Name )
			lc_FileTypeDesc		= loDBFUtils.fileTypeDescription(ln_HexFileType)
			lnDatabases_Count	= ADATABASES(laDatabases)

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN

			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			*-- Header
			loTable			= CREATEOBJECT('CL_DBF_TABLE')
			C_FB2PRG_CODE	= C_FB2PRG_CODE + loTable.toText( ln_HexFileType, ll_FileHasCDX, ll_FileHasMemo, ll_FileIsDBC, lc_DBC_Name, THIS.c_InputFile, lc_FileTypeDesc )


			*-- Genero el DB2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			DO CASE
			CASE toEx.ERRORNO = 13 && Alias not found
				toEx.USERVALUE = 'WARNING!!' + CR_LF ;
					+ 'MAKE SURE YOU ARE NOT USING A TABLE ALIAS ON INDEX KEY EXPRESSIONS!! (ex: index on ' ;
					+ UPPER(JUSTSTEM(THIS.c_InputFile)) + '.field tag keyname)' + CR_LF + CR_LF ;
					+ '��ATENCI�N!!' + CR_LF ;
					+ 'ASEG�RESE DE QUE NO EST� USANDO UN ALIAS DE TABLA EN LAS EXPRESIONES DE LOS �NDICES!! (ej: index on ' ;
					+ UPPER(JUSTSTEM(THIS.c_InputFile)) + '.campo tag nombreclave)'

				*!*				CASE toEx.ErrorNo = 1976 && Cannot resolve backlink
				*!*					toEx.UserValue = 'WARNING!!' + CR_LF ;
				*!*						+ "MAY BE DATABASE FIELDS DOESN'T" ;
				*!*						+ UPPER(JUSTSTEM(THIS.c_InputFile)) + '.field tag keyname)' + CR_LF + CR_LF ;
				*!*						+ '��ATENCI�N!!' + CR_LF ;
				*!*						+ 'ASEG�RESE DE QUE NO EST� USANDO UN ALIAS DE TABLA EN LAS EXPRESIONES DE LOS �NDICES!! (ej: index on ' ;
				*!*						+ UPPER(JUSTSTEM(THIS.c_InputFile)) + '.campo tag nombreclave)'

			ENDCASE
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

			*-- Cierro DBC
			FOR I = 1 TO ADATABASES(laDatabases2)
				IF ASCAN( laDatabases, laDatabases2(I) ) = 0
					SET DATABASE TO (laDatabases2(I))
					CLOSE DATABASES
					EXIT
				ENDIF
			ENDFOR

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_dbc_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_dbc_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toDatabase				(@!    OUT) Objeto generado de clase CL_DBC con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toDatabase, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toDatabase, @toEx )

		#IF .F.
			LOCAL toDatabase AS CL_DBC OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, laDatabases(1), lnDatabases_Count, lnLen

			STORE 0 TO lnCodError

			lnDatabases_Count	= ADATABASES(laDatabases)

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN
			OPEN DATABASE (THIS.c_InputFile) SHARED NOUPDATE

			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			*-- Header
			toDatabase		= CREATEOBJECT('CL_DBC')
			C_FB2PRG_CODE	= C_FB2PRG_CODE + toDatabase.toText()


			*-- Genero el DC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
			CLOSE DATABASES

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_mnx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_mnx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE Convertir
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* totoMenu					(@!    OUT) Objeto generado de clase CL_MENU con la informaci�n leida del texto
		* toEx						(@!    OUT) Objeto con informaci�n del error
		* toFoxbin2prg				(v! IN    ) Referencia al objeto principal
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toMenu, toEx AS EXCEPTION, toFoxbin2prg
		DODEFAULT( @toMenu, @toEx )

		#IF .F.
			LOCAL toMenu AS CL_MENU OF 'FOXBIN2PRG.PRG'
			LOCAL toFoxbin2prg AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, lnLen
			STORE 0 TO lnCodError

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS _TABLAORIG
			SELECT * FROM _TABLAORIG INTO CURSOR TABLABIN
			USE IN (SELECT("_TABLAORIG"))

			*-- Verificaci�n de men� VFP 9
			IF FCOUNT() < 25 OR EMPTY(FIELD("RESNAME")) OR EMPTY(FIELD("SYSRES"))
				ERROR 'Menu [' + (THIS.c_InputFile) + '] is NOT VFP 9 Format! - Please convert to VFP 9 with MODIFY MENU ' + JUSTFNAME((THIS.c_InputFile))
			ENDIF

			*-- Header
			C_FB2PRG_CODE	= C_FB2PRG_CODE + toFoxbin2prg.get_PROGRAM_HEADER()

			toMenu			= CREATEOBJECT('CL_MENU')
			toMenu.get_DataFromTablabin()
			C_FB2PRG_CODE	= C_FB2PRG_CODE + toMenu.toText()


			*-- Genero el MN2
			IF THIS.l_Test
				toMenu	= C_FB2PRG_CODE
			ELSE
				lnLen = LEN( toFoxbin2prg.get_PROGRAM_HEADER() )
				DO CASE
				CASE FILE(THIS.c_OutputFile) AND SUBSTR( FILETOSTR( THIS.c_OutputFile ), lnLen ) == SUBSTR( C_FB2PRG_CODE, lnLen )
					THIS.writeLog( 'El archivo de salida [' + THIS.c_OutputFile + '] no se sobreescribe por ser igual al generado.' )
				CASE toFoxbin2prg.doBackup( .F., .T., '', '', '' ) AND STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDCASE
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_CUS_BASE AS CUSTOM
	*-- Propiedades (Se preservan: CONTROLCOUNT, CONTROLS, OBJECTS, PARENT, CLASS)
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CLASSLIBRARY, COMMENT ;
		, HEIGHT, HELPCONTEXTID, LEFT, NAME ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- M�todos (Se preservan: INIT, DESTROY, ERROR, ADDPROPERTY)
	*HIDDEN ADDOBJECT, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
	, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="l_debug" display="l_Debug"/>] ;
		+ [<memberdata name="set_line" display="set_Line"/>] ;
		+ [<memberdata name="analizarbloque" display="analizarBloque"/>] ;
		+ [<memberdata name="filetypedescription" display="fileTypeDescription"/>] ;
		+ [<memberdata name="totext" display="toText"/>] ;
		+ [</VFPData>]

	l_Debug				= .F.


	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		THIS.l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


	PROCEDURE analizarBloque
	ENDPROC


	PROCEDURE set_Line
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@!    OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(v! IN    ) N�mero de l�nea en an�lisis
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I
		tcLine 	= LTRIM( taCodeLines(I), 0, ' ', CHR(9) )
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_COL_BASE AS COLLECTION
	#IF .F.
		LOCAL THIS AS CL_COL_BASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades (Se preservan: COUNT, KEYSORT, NAME)
	**HIDDEN BASECLASS, CLASS, CLASSLIBRARY, COUNT, COMMENT ;
	, PARENT, PARENTCLASS, TAG

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="l_debug" display="l_Debug"/>] ;
		+ [<memberdata name="analizarbloque" display="analizarBloque"/>] ;
		+ [<memberdata name="set_line" display="set_Line"/>] ;
		+ [<memberdata name="totext" display="toText"/>] ;
		+ [</VFPData>]

	l_Debug				= .F.


	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		THIS.l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


	PROCEDURE analizarBloque
	ENDPROC


	PROCEDURE set_Line
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@!    OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(v! IN    ) N�mero de l�nea en an�lisis
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I
		tcLine 	= LTRIM( taCodeLines(I), 0, ' ', CHR(9) )
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taArray					(@?    OUT) Array de conexiones
		* tnArray_Count				(@?    OUT) Cantidad de conexiones
		*---------------------------------------------------------------------------------------------------
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_MODULO AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_MODULO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_ole" display="add_OLE"/>] ;
		+ [<memberdata name="add_class" display="add_Class"/>] ;
		+ [<memberdata name="existeobjetoole" display="existeObjetoOLE"/>] ;
		+ [<memberdata name="_clases" display="_Clases"/>] ;
		+ [<memberdata name="_clases_count" display="_Clases_Count"/>] ;
		+ [<memberdata name="_includefile" display="_IncludeFile"/>] ;
		+ [<memberdata name="_ole_objs" display="_Ole_Objs"/>] ;
		+ [<memberdata name="_ole_obj_count" display="_Ole_Obj_Count"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [</VFPData>]


	DIMENSION _Ole_Objs[1], _Clases[1]
	_Version			= 0
	_SourceFile			= ''
	_Ole_Obj_count		= 0
	_Clases_Count		= 0
	_includeFile		= ''


	************************************************************************************************
	PROCEDURE add_OLE
		LPARAMETERS toOle

		#IF .F.
			LOCAL toOle AS CL_OLE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Ole_Obj_count	= THIS._Ole_Obj_count + 1
		DIMENSION THIS._Ole_Objs( THIS._Ole_Obj_count )
		THIS._Ole_Objs( THIS._Ole_Obj_count )	= toOle
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Class
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Clases_Count	= THIS._Clases_Count + 1
		DIMENSION THIS._Clases( THIS._Clases_Count )
		THIS._Clases( THIS._Clases_Count )	= toClase
	ENDPROC


	************************************************************************************************
	PROCEDURE existeObjetoOLE
		*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
		LPARAMETERS tcNombre, X
		LOCAL llExiste

		FOR X = 1 TO THIS._Ole_Obj_count
			IF THIS._Ole_Objs(X)._Nombre == tcNombre
				llExiste = .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN llExiste
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_OLE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_OLE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_checksum" display="_CheckSum"/>] ;
		+ [<memberdata name="_nombre" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" display="_ObjName"/>] ;
		+ [<memberdata name="_parent" display="_Parent"/>] ;
		+ [<memberdata name="_value" display="_Value"/>] ;
		+ [</VFPData>]

	_Nombre		= ''
	_Parent		= ''
	_ObjName	= ''
	_CheckSum	= ''
	_Value		= ''
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_CLASE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_CLASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_procedure" display="add_Procedure"/>] ;
		+ [<memberdata name="add_property" display="add_Property"/>] ;
		+ [<memberdata name="add_object" display="add_Object"/>] ;
		+ [<memberdata name="_addobject_count" display="_AddObject_Count"/>] ;
		+ [<memberdata name="_addobjects" display="_AddObjects"/>] ;
		+ [<memberdata name="_baseclass" display="_BaseClass"/>] ;
		+ [<memberdata name="_class" display="_Class"/>] ;
		+ [<memberdata name="_classicon" display="_ClassIcon"/>] ;
		+ [<memberdata name="_classloc" display="_ClassLoc"/>] ;
		+ [<memberdata name="_comentario" display="_Comentario"/>] ;
		+ [<memberdata name="_defined_pam" display="_Defined_PAM"/>] ;
		+ [<memberdata name="_definicion" display="_Definicion"/>] ;
		+ [<memberdata name="_fin" display="_Fin"/>] ;
		+ [<memberdata name="_fin_cab" display="_Fin_Cab"/>] ;
		+ [<memberdata name="_fin_cuerpo" display="_Fin_Cuerpo"/>] ;
		+ [<memberdata name="_hiddenmethods" display="_HiddenMethods"/>] ;
		+ [<memberdata name="_hiddenprops" display="_HiddenProps"/>] ;
		+ [<memberdata name="_includefile" display="_IncludeFile"/>] ;
		+ [<memberdata name="_inicio" display="_Inicio"/>] ;
		+ [<memberdata name="_ini_cab" display="_Ini_Cab"/>] ;
		+ [<memberdata name="_ini_cuerpo" display="_Ini_Cuerpo"/>] ;
		+ [<memberdata name="_metadata" display="_MetaData"/>] ;
		+ [<memberdata name="_nombre" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" display="_ObjName"/>] ;
		+ [<memberdata name="_ole" display="_Ole"/>] ;
		+ [<memberdata name="_ole2" display="_Ole2"/>] ;
		+ [<memberdata name="_olepublic" display="_OlePublic"/>] ;
		+ [<memberdata name="_parent" display="_Parent"/>] ;
		+ [<memberdata name="_procedures" display="_Procedures"/>] ;
		+ [<memberdata name="_procedure_count" display="_Procedure_Count"/>] ;
		+ [<memberdata name="_projectclassicon" display="_ProjectClassIcon"/>] ;
		+ [<memberdata name="_protectedmethods" display="_ProtectedMethods"/>] ;
		+ [<memberdata name="_protectedprops" display="_ProtectedProps"/>] ;
		+ [<memberdata name="_props" display="_Props"/>] ;
		+ [<memberdata name="_prop_count" display="_Prop_Count"/>] ;
		+ [<memberdata name="_scale" display="_Scale"/>] ;
		+ [<memberdata name="_timestamp" display="_TimeStamp"/>] ;
		+ [<memberdata name="_uniqueid" display="_UniqueID"/>] ;
		+ [<memberdata name="_properties" display="_PROPERTIES"/>] ;
		+ [<memberdata name="_protected" display="_PROTECTED"/>] ;
		+ [<memberdata name="_methods" display="_METHODS"/>] ;
		+ [<memberdata name="_reserved1" display="_RESERVED1"/>] ;
		+ [<memberdata name="_reserved2" display="_RESERVED2"/>] ;
		+ [<memberdata name="_reserved3" display="_RESERVED3"/>] ;
		+ [<memberdata name="_reserved4" display="_RESERVED4"/>] ;
		+ [<memberdata name="_reserved5" display="_RESERVED5"/>] ;
		+ [<memberdata name="_reserved6" display="_RESERVED6"/>] ;
		+ [<memberdata name="_reserved7" display="_RESERVED7"/>] ;
		+ [<memberdata name="_reserved8" display="_RESERVED8"/>] ;
		+ [<memberdata name="_user" display="_USER"/>] ;
		+ [</VFPData>]


	DIMENSION _Props[1,2], _AddObjects[1], _Procedures[1]
	_Nombre				= ''
	_ObjName			= ''
	_Parent				= ''
	_Definicion			= ''
	_Class				= ''
	_ClassLoc			= ''
	_OlePublic			= ''
	_Ole				= ''
	_Ole2				= ''
	_UniqueID			= ''
	_Comentario			= ''
	_ClassIcon			= ''
	_ProjectClassIcon	= ''
	_Inicio				= 0
	_Fin				= 0
	_Ini_Cab			= 0
	_Fin_Cab			= 0
	_Ini_Cuerpo			= 0
	_Fin_Cuerpo			= 0
	_Prop_Count			= 0
	_HiddenProps		= ''
	_ProtectedProps		= ''
	_HiddenMethods		= ''
	_ProtectedMethods	= ''
	_MetaData			= ''
	_BaseClass			= ''
	_TimeStamp			= ''
	_Scale				= ''
	_Defined_PAM		= ''
	_includeFile		= ''
	_AddObject_Count	= 0
	_Procedure_Count	= 0
	_PROPERTIES			= ''
	_PROTECTED			= ''
	_METHODS			= ''
	_RESERVED1			= ''
	_RESERVED2			= ''
	_RESERVED3			= ''
	_RESERVED4			= ''
	_RESERVED5			= ''
	_RESERVED6			= ''
	_RESERVED7			= ''
	_RESERVED8			= ''
	_User				= ''


	************************************************************************************************
	PROCEDURE add_Procedure
		LPARAMETERS toProcedure

		#IF .F.
			LOCAL toProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Procedure_Count	= THIS._Procedure_Count + 1
		DIMENSION THIS._Procedures( THIS._Procedure_Count )
		THIS._Procedures( THIS._Procedure_Count )	= toProcedure
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Property
		LPARAMETERS tcProperty AS STRING, tcValue AS STRING, tcComment AS STRING
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 3 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
		THIS._Props( THIS._Prop_Count, 2 )	= tcValue
		THIS._Props( THIS._Prop_Count, 3 )	= tcComment
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Object
		LPARAMETERS toObjeto

		#IF .F.
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._AddObject_Count	= THIS._AddObject_Count + 1
		DIMENSION THIS._AddObjects( THIS._AddObject_Count )
		THIS._AddObjects( THIS._AddObject_Count )	= toObjeto
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROCEDURE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_line" display="add_Line"/>] ;
		+ [<memberdata name="_comentario" display="_Comentario"/>] ;
		+ [<memberdata name="_nombre" display="_Nombre"/>] ;
		+ [<memberdata name="_procline_count" display="_ProcLine_Count"/>] ;
		+ [<memberdata name="_proclines" display="_ProcLines"/>] ;
		+ [<memberdata name="_proctype" display="_ProcType"/>] ;
		+ [</VFPData>]

	DIMENSION _ProcLines[1]
	_Nombre			= ''
	_ProcType		= ''
	_Comentario		= ''
	_ProcLine_Count	= 0


	************************************************************************************************
	PROCEDURE add_Line
		LPARAMETERS tcLine AS STRING
		THIS._ProcLine_Count	= THIS._ProcLine_Count + 1
		DIMENSION THIS._ProcLines( THIS._ProcLine_Count )
		THIS._ProcLines( THIS._ProcLine_Count )	= tcLine
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_OBJETO AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_procedure" display="add_Procedure"/>] ;
		+ [<memberdata name="add_property" display="add_Property"/>] ;
		+ [<memberdata name="_baseclass" display="_BaseClass"/>] ;
		+ [<memberdata name="_class" display="_Class"/>] ;
		+ [<memberdata name="_classlib" display="_ClassLib"/>] ;
		+ [<memberdata name="_nombre" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" display="_ObjName"/>] ;
		+ [<memberdata name="_ole" display="_Ole"/>] ;
		+ [<memberdata name="_ole2" display="_Ole2"/>] ;
		+ [<memberdata name="_parent" display="_Parent"/>] ;
		+ [<memberdata name="_writeorder" display="_WriteOrder"/>] ;
		+ [<memberdata name="_procedures" display="_Procedures"/>] ;
		+ [<memberdata name="_procedure_count" display="_Procedure_Count"/>] ;
		+ [<memberdata name="_props" display="_Props"/>] ;
		+ [<memberdata name="_prop_count" display="_Prop_Count"/>] ;
		+ [<memberdata name="_timestamp" display="_TimeStamp"/>] ;
		+ [<memberdata name="_uniqueid" display="_UniqueID"/>] ;
		+ [<memberdata name="_user" display="_User"/>] ;
		+ [<memberdata name="_zorder" display="_ZOrder"/>] ;
		+ [</VFPData>]

	DIMENSION _Props[1,1], _Procedures[1]
	_Nombre				= ''
	_ObjName			= ''
	_Parent				= ''
	_Class				= ''
	_ClassLib			= ''
	_BaseClass			= ''
	_UniqueID			= ''
	_TimeStamp			= 0
	_Ole				= ''
	_Ole2				= ''
	_Prop_Count			= 0
	_Procedure_Count	= 0
	_User				= ''
	_WriteOrder			= 0
	_ZOrder				= 0


	************************************************************************************************
	PROCEDURE add_Procedure
		LPARAMETERS toProcedure

		#IF .F.
			LOCAL toProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF '.' $ THIS._Nombre
			toProcedure._Nombre	= SUBSTR( toProcedure._Nombre, AT( '.', toProcedure._Nombre, OCCURS( '.', THIS._Nombre) ) + 1 )
		ENDIF

		THIS._Procedure_Count	= THIS._Procedure_Count + 1
		DIMENSION THIS._Procedures( THIS._Procedure_Count )
		THIS._Procedures( THIS._Procedure_Count )	= toProcedure
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Property
		LPARAMETERS tcProperty AS STRING, tcValue AS STRING
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 2 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
		THIS._Props( THIS._Prop_Count, 2 )	= tcValue
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_REPORT AS CL_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_REPORT OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_timestamp" display="_TimeStamp"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [</VFPData>]

	*-- Report.Info
	_TimeStamp			= 0
	_Version			= ''
	_SourceFile			= ''


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJECT AS CL_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_cmntstyle" display="_CmntStyle"/>] ;
		+ [<memberdata name="_debug" display="_Debug"/>] ;
		+ [<memberdata name="_encrypted" display="_Encrypted"/>] ;
		+ [<memberdata name="_homedir" display="_HomeDir"/>] ;
		+ [<memberdata name="_icon" display="_Icon"/>] ;
		+ [<memberdata name="_mainprog" display="_MainProg"/>] ;
		+ [<memberdata name="_nologo" display="_NoLogo"/>] ;
		+ [<memberdata name="_objrev" display="_ObjRev"/>] ;
		+ [<memberdata name="_projecthookclass" display="_ProjectHookClass"/>] ;
		+ [<memberdata name="_projecthooklibrary" display="_ProjectHookLibrary"/>] ;
		+ [<memberdata name="_savecode" display="_SaveCode"/>] ;
		+ [<memberdata name="_serverinfo" display="_ServerInfo"/>] ;
		+ [<memberdata name="_serverhead" display="_ServerHead"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [<memberdata name="_timestamp" display="_TimeStamp"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [<memberdata name="_address" display="_Address"/>] ;
		+ [<memberdata name="_author" display="_Author"/>] ;
		+ [<memberdata name="_company" display="_Company"/>] ;
		+ [<memberdata name="_city" display="_City"/>] ;
		+ [<memberdata name="_state" display="_State"/>] ;
		+ [<memberdata name="_postalcode" display="_PostalCode"/>] ;
		+ [<memberdata name="_country" display="_Country"/>] ;
		+ [<memberdata name="_comments" display="_Comments"/>] ;
		+ [<memberdata name="_companyname" display="_CompanyName"/>] ;
		+ [<memberdata name="_filedescription" display="_FileDescription"/>] ;
		+ [<memberdata name="_legalcopyright" display="_LegalCopyright"/>] ;
		+ [<memberdata name="_legaltrademark" display="_LegalTrademark"/>] ;
		+ [<memberdata name="_productname" display="_ProductName"/>] ;
		+ [<memberdata name="_majorver" display="_MajorVer"/>] ;
		+ [<memberdata name="_minorver" display="_MinorVer"/>] ;
		+ [<memberdata name="_revision" display="_Revision"/>] ;
		+ [<memberdata name="_languageid" display="_LanguageID"/>] ;
		+ [<memberdata name="_autoincrement" display="_AutoIncrement"/>] ;
		+ [<memberdata name="getformatteddeviceinfotext" display="getFormattedDeviceInfoText"/>] ;
		+ [<memberdata name="parsedeviceinfo" display="parseDeviceInfo"/>] ;
		+ [<memberdata name="parsenullterminatedvalue" display="parseNullTerminatedValue"/>] ;
		+ [<memberdata name="setparsedinfoline" display="setParsedInfoLine"/>] ;
		+ [<memberdata name="setparsedprojinfoline" display="setParsedProjInfoLine"/>] ;
		+ [<memberdata name="getrowdeviceinfo" display="getRowDeviceInfo"/>] ;
		+ [</VFPData>]


	*-- Proj.Info
	_CmntStyle			= 1
	_Debug				= .F.
	_Encrypted			= .F.
	_HomeDir			= ''
	_Icon				= ''
	_ID					= ''
	_MainProg			= ''
	_NoLogo				= .F.
	_ObjRev				= 0
	_ProjectHookClass	= ''
	_ProjectHookLibrary	= ''
	_SaveCode			= .T.
	_ServerHead			= NULL
	_ServerInfo			= ''
	_SourceFile			= ''
	_TimeStamp			= 0
	_Version			= ''

	*-- Dev.info
	_Author				= ''
	_Company			= ''
	_Address			= ''
	_City				= ''
	_State				= ''
	_PostalCode			= ''
	_Country			= ''

	_Comments			= ''
	_CompanyName		= ''
	_FileDescription	= ''
	_LegalCopyright		= ''
	_LegalTrademark		= ''
	_ProductName		= ''
	_MajorVer			= ''
	_MinorVer			= ''
	_Revision			= ''
	_LanguageID			= ''
	_AutoIncrement		= ''


	************************************************************************************************
	PROCEDURE INIT
		DODEFAULT()
		THIS._ServerHead	= CREATEOBJECT('CL_PROJ_SRV_HEAD')
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedProjInfoLine
		LPARAMETERS tcProjInfoLine
		THIS.setParsedInfoLine( THIS, tcProjInfoLine )
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedInfoLine
		LPARAMETERS toObject, tcInfoLine
		LOCAL lcAsignacion, lcCurDir
		*lcCurDir	= ADDBS(JUSTPATH(THIS._SourceFile))
		lcCurDir	= ADDBS(THIS._HomeDir)
		IF LEFT(tcInfoLine,1) == '.'
			lcAsignacion	= 'toObject' + tcInfoLine
		ELSE
			lcAsignacion	= 'toObject.' + tcInfoLine
		ENDIF
		&lcAsignacion.
	ENDPROC


	************************************************************************************************
	PROCEDURE parseNullTerminatedValue
		LPARAMETERS tcDevInfo, tnPos, tnLen
		LOCAL lcValue, lnNullPos
		lcStr		= SUBSTR( tcDevInfo, tnPos, tnLen )
		lnNullPos	= AT(CHR(0), lcStr )
		IF lnNullPos = 0
			lcValue		= CHRTRAN( LEFT( lcStr, tnLen ), ['], ["] )
		ELSE
			lcValue		= CHRTRAN( LEFT( lcStr, MIN(tnLen, lnNullPos - 1 ) ), ['], ["] )
		ENDIF
		RETURN lcValue
	ENDPROC


	************************************************************************************************
	PROCEDURE parseDeviceInfo
		LPARAMETERS tcDevInfo

		TRY
			WITH THIS
				._Author			= .parseNullTerminatedValue( @tcDevInfo, 1, 45 )
				._Company			= .parseNullTerminatedValue( @tcDevInfo, 47, 45 )
				._Address			= .parseNullTerminatedValue( @tcDevInfo, 93, 45 )
				._City				= .parseNullTerminatedValue( @tcDevInfo, 139, 20 )
				._State				= .parseNullTerminatedValue( @tcDevInfo, 160, 5 )
				._PostalCode		= .parseNullTerminatedValue( @tcDevInfo, 166, 10 )
				._Country			= .parseNullTerminatedValue( @tcDevInfo, 177, 45 )
				*--
				._Comments			= .parseNullTerminatedValue( @tcDevInfo, 223, 254 )
				._CompanyName		= .parseNullTerminatedValue( @tcDevInfo, 478, 254 )
				._FileDescription	= .parseNullTerminatedValue( @tcDevInfo, 733, 254 )
				._LegalCopyright	= .parseNullTerminatedValue( @tcDevInfo, 988, 254 )
				._LegalTrademark	= .parseNullTerminatedValue( @tcDevInfo, 1243, 254 )
				._ProductName		= .parseNullTerminatedValue( @tcDevInfo, 1498, 254 )
				._MajorVer			= .parseNullTerminatedValue( @tcDevInfo, 1753, 4 )
				._MinorVer			= .parseNullTerminatedValue( @tcDevInfo, 1758, 4 )
				._Revision			= .parseNullTerminatedValue( @tcDevInfo, 1763, 4 )
				._LanguageID		= .parseNullTerminatedValue( @tcDevInfo, 1768, 19 )
				._AutoIncrement		= IIF( SUBSTR( tcDevInfo, 1788, 1 ) = CHR(1), '1', '0' )
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

	ENDPROC


	************************************************************************************************
	PROCEDURE getRowDeviceInfo
		LPARAMETERS tcDevInfo

		TRY
			IF VARTYPE(tcDevInfo) # 'C' OR LEN(tcDevInfo) = 0
				tcDevInfo	= REPLICATE( CHR(0), 1795 )
			ENDIF

			WITH THIS
				tcDevInfo	= STUFF( tcDevInfo, 1, LEN(._Author), ._Author)
				tcDevInfo	= STUFF( tcDevInfo, 47, LEN(._Company), ._Company)
				tcDevInfo	= STUFF( tcDevInfo, 93, LEN(._Address), ._Address)
				tcDevInfo	= STUFF( tcDevInfo, 139, LEN(._City), ._City)
				tcDevInfo	= STUFF( tcDevInfo, 160, LEN(._State), ._State)
				tcDevInfo	= STUFF( tcDevInfo, 166, LEN(._PostalCode), ._PostalCode)
				tcDevInfo	= STUFF( tcDevInfo, 177, LEN(._Country), ._Country)
				tcDevInfo	= STUFF( tcDevInfo, 223, LEN(._Comments), ._Comments)
				tcDevInfo	= STUFF( tcDevInfo, 478, LEN(._CompanyName), ._CompanyName)
				tcDevInfo	= STUFF( tcDevInfo, 733, LEN(._FileDescription), ._FileDescription)
				tcDevInfo	= STUFF( tcDevInfo, 988, LEN(._LegalCopyright), ._LegalCopyright)
				tcDevInfo	= STUFF( tcDevInfo, 1243, LEN(._LegalTrademark), ._LegalTrademark)
				tcDevInfo	= STUFF( tcDevInfo, 1498, LEN(._ProductName), ._ProductName)
				tcDevInfo	= STUFF( tcDevInfo, 1753, LEN(._MajorVer), ._MajorVer)
				tcDevInfo	= STUFF( tcDevInfo, 1758, LEN(._MinorVer), ._MinorVer)
				tcDevInfo	= STUFF( tcDevInfo, 1763, LEN(._Revision), ._Revision)
				tcDevInfo	= STUFF( tcDevInfo, 1768, LEN(._LanguageID), ._LanguageID)
				tcDevInfo	= STUFF( tcDevInfo, 1788, 1, CHR(VAL(._AutoIncrement)))
				tcDevInfo	= STUFF( tcDevInfo, 1792, 1, CHR(1))
			ENDWITH && THIS

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN tcDevInfo
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedDeviceInfoText
		TRY
			LOCAL lcText
			lcText		= ''

			WITH THIS
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_DEVINFO_I>>
					_Author = "<<._Author>>"
					_Company = "<<._Company>>"
					_Address = "<<._Address>>"
					_City = "<<._City>>"
					_State = "<<._State>>"
					_PostalCode = "<<._PostalCode>>"
					_Country = "<<._Country>>"
					*--
					_Comments = "<<._Comments>>"
					_CompanyName = "<<._CompanyName>>"
					_FileDescription = "<<._FileDescription>>"
					_LegalCopyright = "<<._LegalCopyright>>"
					_LegalTrademark = "<<._LegalTrademark>>"
					_ProductName = "<<._ProductName>>"
					_MajorVer = "<<._MajorVer>>"
					_MinorVer = "<<._MinorVer>>"
					_Revision = "<<._Revision>>"
					_LanguageID = "<<._LanguageID>>"
					_AutoIncrement = "<<._AutoIncrement>>"
					<<C_DEVINFO_F>>
					<<>>
				ENDTEXT
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE



*******************************************************************************************************************
DEFINE CLASS CL_DBC_COL_BASE AS CL_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_COL_BASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="__objectid" display="__ObjectID"/>] ;
		+ [<memberdata name="updatedbc" display="updateDBC"/>] ;
		+ [</VFPData>]

	*PROTECTED __ObjectID, __ObjectType
	__ObjectID		= 0
	_Name			= ''


	PROCEDURE updateDBC
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFile				(v! IN    ) Nombre del archivo de salida
		* tnLastID					(@! IN    ) �ltimo n�mero de ID usado
		* tnParentID				(v! IN    ) ID del objeto Padre
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_OutputFile, tnLastID, tnParentID
		LOCAL loObject

		FOR EACH loObject IN THIS FOXOBJECT
			loObject.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
		ENDFOR

		RETURN
	ENDPROC


	PROCEDURE __ObjectID_ACCESS
		RETURN THIS.PARENT.__ObjectID
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_BASE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_BASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_property" display="Add_Property"/>] ;
		+ [<memberdata name="analizarbloque_comment" display="analizarBloque_Comment"/>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="__objectid" display="__ObjectID"/>] ;
		+ [<memberdata name="dbgetprop" display="DBGETPROP"/>] ;
		+ [<memberdata name="dbsetprop" display="DBSETPROP"/>] ;
		+ [<memberdata name="getallpropertiesfromobjectname" display="getAllPropertiesFromObjectname"/>] ;
		+ [<memberdata name="getbinpropertydatarecord" display="getBinPropertyDataRecord"/>] ;
		+ [<memberdata name="getcodememo" display="getCodeMemo"/>] ;
		+ [<memberdata name="getdbcpropertyidbyname" display="getDBCPropertyIDByName"/>] ;
		+ [<memberdata name="getdbcpropertynamebyid" display="getDBCPropertyNameByID"/>] ;
		+ [<memberdata name="getdbcpropertyvaluetypebypropertyid" display="getDBCPropertyValueTypeByPropertyID"/>] ;
		+ [<memberdata name="getid" display="getID"/>] ;
		+ [<memberdata name="getobjecttype" display="getObjectType"/>] ;
		+ [<memberdata name="getbinmemofromproperties" display="getBinMemoFromProperties"/>] ;
		+ [<memberdata name="getreferentialintegrityinfo" display="getReferentialIntegrityInfo"/>] ;
		+ [<memberdata name="getusermemo" display="getUserMemo"/>] ;
		+ [<memberdata name="setnextid" display="setNextID"/>] ;
		+ [<memberdata name="updatedbc" display="updateDBC"/>] ;
		+ [</VFPData>]


	__ObjectID		= 0
	_Name			= ''


	FUNCTION add_Property
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcPropertyName			(v! IN    ) Nombre de la propiedad a agregar o modificar
		* teValue					(v! IN    ) Valor de la propiedad
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcPropertyName, teValue

		LOCAL lnPropertyID, tcDataType, leValue, llRetorno, lnDataLen
		lnPropertyID	= THIS.getDBCPropertyIDByName( SUBSTR(tcPropertyName,2) )

		IF lnPropertyID = -1
			IF PCOUNT()=1
				llRetorno	= THIS.ADDPROPERTY( tcPropertyName )
			ELSE
				llRetorno	= THIS.ADDPROPERTY( tcPropertyName, teValue )
			ENDIF
		ELSE
			tcDataType	= THIS.getDBCPropertyValueTypeByPropertyID( lnPropertyID )
			lnDataLen	= LEN(teValue)

			DO CASE
			CASE tcDataType = 'L'
				IF lnDataLen = 0
					leValue		= .F.
				ELSE
					leValue		= CAST( teValue AS (tcDataType) )
				ENDIF

			CASE INLIST(tcDataType, 'N', 'B')
				IF lnDataLen = 0
					leValue		= 0
				ELSE
					leValue		= CAST( teValue AS (tcDataType) (lnDataLen) )
				ENDIF

			OTHERWISE	&& Asumo 'C'
				IF lnDataLen = 0
					leValue		= ''
				ELSE
					leValue		= teValue
				ENDIF

			ENDCASE

			llRetorno	= THIS.ADDPROPERTY( tcPropertyName, leValue )
		ENDIF

		RETURN llRetorno
	ENDFUNC


	PROCEDURE analizarBloque_Comment
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		IF LEFT(tcLine, LEN('<Comment>')) == '<Comment>'
			LOCAL lcValue
			llBloqueEncontrado	= .T.
			lcValue	= STREXTRACT( taCodeLines(I), '<Comment>', '</Comment>', 1, 2 )

			IF NOT '</Comment>' $ tcLine THEN
				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE '</Comment>' $ tcLine	&& Fin
						lcValue	= lcValue + CR_LF + LEFT( taCodeLines(I), AT( '</Comment>', taCodeLines(I) ) - 1 )
						EXIT

					OTHERWISE	&& L�nea de Stored Procedure
						lcValue	= lcValue + CR_LF + taCodeLines(I)
					ENDCASE
				ENDFOR
			ENDIF

			THIS.ADDPROPERTY( '_Comment', lcValue )
		ENDIF
	ENDPROC


	PROCEDURE getAllPropertiesFromObjectname
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcName					(v! IN    ) Nombre del objeto
		* tcType					(v! IN    ) Tipo de objeto (Table, Index, Field, View, Relation)
		* taProperties				(@!    OUT) Array con las propiedades encontradas y sus valores
		* tnProperty_Count			(@!    OUT) Cantidad de propiedades encontradas
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcName, tcType, taProperties, tnProperty_Count

		EXTERNAL ARRAY taProperties	&& STRUCTURE: PropName,RecordLen,DataIDLen,DataID,DataType,Data

		TRY
			LOCAL lcValue, leValue, lnSelect, laProperty(1,1), lnRecordLen, lcBinRecord, lnPropertyID ;
				, lnLastPos, lnLenCCode, lcDataType, lcPropName, lcDBF, lnLenData, lnLenHeader
			tnProperty_Count	= 0
			lnSelect	= SELECT()
			leValue		= ''
			tcName		= PROPER(RTRIM(tcName))
			tcType		= PROPER(RTRIM(tcType))
			tcProperty	= PROPER(RTRIM(tcProperty))
			lcDBF		= DBF()

			SELECT 0
			USE (lcDBF) AGAIN SHARED NOUPDATE ALIAS C_TABLABIN2

			IF INLIST( tcType, 'Index', 'Field' )
				SELECT TB.Property FROM C_TABLABIN2 TB ;
					INNER JOIN C_TABLABIN2 TB2 ON STR(TB.ParentID)+TB.ObjectType+LOWER(TB.objectName) = STR(TB2.ObjectID)+PADR(tcType,10)+PADR(LOWER(JUSTEXT(tcName)),128) ;
					AND TB2.objectName = PADR(LOWER(JUSTSTEM(tcName)),128) ;
					INTO ARRAY laProperty

			ELSE
				SELECT TB.Property FROM C_TABLABIN2 TB ;
					INNER JOIN C_TABLABIN2 TB2 ON STR(TB.ParentID)+TB.ObjectType+LOWER(TB.objectName) = STR(TB2.ObjectID)+PADR(tcType,10)+PADR(LOWER(tcName),128) ;
					INTO ARRAY laProperty

			ENDIF

			IF _TALLY > 0
				IF EMPTY(laProperty(1,1))
					EXIT
				ENDIF

				lnLastPos		= 1

				DO WHILE lnLastPos < LEN(laProperty(1,1))
					tnProperty_Count	= tnProperty_Count + 1
					DIMENSION taProperties( tnProperty_Count,6 )

					lnRecordLen		= CTOBIN( SUBSTR(laProperty(1,1), lnLastPos, 4), "4RS" )
					lcBinRecord		= SUBSTR(laProperty(1,1), lnLastPos, lnRecordLen)
					lnLenCCode		= CTOBIN( SUBSTR(lcBinRecord, 4+1, 2), "2RS" )
					lnPropertyID	= ASC( SUBSTR(lcBinRecord, 4+2+1, lnLenCCode) )
					lcPropName		= THIS.getDBCPropertyNameByID( lnPropertyID )
					lcDataType		= THIS.getDBCPropertyValueTypeByPropertyID( lnPropertyID )
					lnLenHeader		= 4 + 2 + lnLenCCode
					lcValue			= SUBSTR(lcBinRecord, lnLenHeader + 1)

					DO CASE
					CASE lcDataType = 'B'
						IF lnLenHeader = lnRecordLen
							leValue		= 0
						ELSE
							leValue		= ASC( lcValue )
						ENDIF

					CASE lcDataType = 'L'
						IF lnLenHeader = lnRecordLen
							leValue		= .F.
						ELSE
							leValue		= ( CTOBIN( lcValue, "1S" ) = 1 )
						ENDIF

					CASE lcDataType = 'N'
						IF lnLenHeader = lnRecordLen
							leValue		= 0
						ELSE
							leValue		= CTOBIN( lcValue, "4S" )
						ENDIF

					OTHERWISE && Asume 'C'
						IF lnLenHeader = lnRecordLen
							leValue		= ''
						ELSE
							leValue		= LEFT( lcValue, AT( CHR(0), lcValue ) - 1 )
						ENDIF
					ENDCASE

					taProperties( tnProperty_Count,1 )	= lcPropName
					taProperties( tnProperty_Count,2 )	= lnRecordLen
					taProperties( tnProperty_Count,3 )	= lnLenCCode
					taProperties( tnProperty_Count,4 )	= lnPropertyID
					taProperties( tnProperty_Count,5 )	= lcDataType
					taProperties( tnProperty_Count,6 )	= leValue

					lnLastPos	= lnLastPos + lnRecordLen
				ENDDO
			ELSE
				ERROR 1562, (tcName)
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("C_TABLABIN2"))
			SELECT (lnSelect)
		ENDTRY

		RETURN leValue
	ENDPROC


	PROCEDURE getDBCPropertyIDByName
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcPropertyName			(v! IN    ) Nombre de la propiedad
		* tlRethrowError			(v? IN    ) Indica si se debe relanzar el error o solo devolver -1
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcPropertyName, tlRethrowError
		LOCAL lnPropertyID
		tcPropertyName	= LOWER(RTRIM(tcPropertyName))

		DO CASE
		CASE tcPropertyName == 'null'
			lnPropertyID	= 0
		CASE tcPropertyName == 'path'
			lnPropertyID	= 1
		CASE tcPropertyName == 'class'
			lnPropertyID	= 2
		CASE tcPropertyName == 'comment'
			lnPropertyID	= 7
		CASE tcPropertyName == 'ruleexpression'
			lnPropertyID	= 9
		CASE tcPropertyName == 'ruletext'
			lnPropertyID	= 10
		CASE tcPropertyName == 'defaultvalue'
			lnPropertyID	= 11
		CASE tcPropertyName == 'parameterlist'
			lnPropertyID	= 12
		CASE tcPropertyName == 'childtag'
			lnPropertyID	= 13
		CASE tcPropertyName == 'inserttrigger'
			lnPropertyID	= 14
		CASE tcPropertyName == 'updatetrigger'
			lnPropertyID	= 15
		CASE tcPropertyName == 'deletetrigger'
			lnPropertyID	= 16
		CASE tcPropertyName == 'isunique'
			lnPropertyID	= 17
		CASE tcPropertyName == 'parenttable'
			lnPropertyID	= 18
		CASE tcPropertyName == 'parenttag'
			lnPropertyID	= 19
		CASE tcPropertyName == 'primarykey'
			lnPropertyID	= 20
		CASE tcPropertyName == 'version'
			lnPropertyID	= 24
		CASE tcPropertyName == 'batchupdatecount'
			lnPropertyID	= 28
		CASE tcPropertyName == 'datasource'
			lnPropertyID	= 29
		CASE tcPropertyName == 'connectname'
			lnPropertyID	= 32
		CASE tcPropertyName == 'updatename'
			lnPropertyID	= 35
		CASE tcPropertyName == 'fetchmemo'
			lnPropertyID	= 36
		CASE tcPropertyName == 'fetchsize'
			lnPropertyID	= 37
		CASE tcPropertyName == 'keyfield'
			lnPropertyID	= 38
		CASE tcPropertyName == 'maxrecords'
			lnPropertyID	= 39
		CASE tcPropertyName == 'shareconnection'
			lnPropertyID	= 40
		CASE tcPropertyName == 'sourcetype'
			lnPropertyID	= 41
		CASE tcPropertyName == 'sql'
			lnPropertyID	= 42
		CASE tcPropertyName == 'tables'
			lnPropertyID	= 43
		CASE tcPropertyName == 'sendupdates'
			lnPropertyID	= 44
		CASE tcPropertyName == 'updatablefield' OR tcPropertyName == 'updatable'
			lnPropertyID	= 45
		CASE tcPropertyName == 'updatetype'
			lnPropertyID	= 46
		CASE tcPropertyName == 'usememosize'
			lnPropertyID	= 47
		CASE tcPropertyName == 'wheretype'
			lnPropertyID	= 48
		CASE tcPropertyName == 'displayclass'	&& Undocumented
			lnPropertyID	= 50
		CASE tcPropertyName == 'displayclasslibrary'	&& Undocumented
			lnPropertyID	= 51
		CASE tcPropertyName == 'inputmask'	&& Undocumented
			lnPropertyID	= 54
		CASE tcPropertyName == 'format'	&& Undocumented
			lnPropertyID	= 55
		CASE tcPropertyName == 'caption'
			lnPropertyID	= 56
		CASE tcPropertyName == 'asynchronous'
			lnPropertyID	= 64
		CASE tcPropertyName == 'batchmode'
			lnPropertyID	= 65
		CASE tcPropertyName == 'connectstring'
			lnPropertyID	= 66
		CASE tcPropertyName == 'connecttimeout'
			lnPropertyID	= 67
		CASE tcPropertyName == 'displogin'
			lnPropertyID	= 68
		CASE tcPropertyName == 'dispwarnings'
			lnPropertyID	= 69
		CASE tcPropertyName == 'idletimeout'
			lnPropertyID	= 70
		CASE tcPropertyName == 'querytimeout'
			lnPropertyID	= 71
		CASE tcPropertyName == 'password'
			lnPropertyID	= 72
		CASE tcPropertyName == 'transactions'
			lnPropertyID	= 73
		CASE tcPropertyName == 'userid'
			lnPropertyID	= 74
		CASE tcPropertyName == 'waittime'
			lnPropertyID	= 75
		CASE tcPropertyName == 'timestamp'
			lnPropertyID	= 76
		CASE tcPropertyName == 'datatype'
			lnPropertyID	= 77
		CASE tcPropertyName == 'packetsize'	&& Undocumented
			lnPropertyID	= 78
		CASE tcPropertyName == 'database'	&& Undocumented
			lnPropertyID	= 79
		CASE tcPropertyName == 'prepared'	&& Undocumented
			lnPropertyID	= 80
		CASE tcPropertyName == 'comparememo'	&& Undocumented
			lnPropertyID	= 81
		CASE tcPropertyName == 'fetchasneeded'	&& Undocumented
			lnPropertyID	= 82
		CASE tcPropertyName == 'offline'	&& Undocumented
			lnPropertyID	= 83
		CASE tcPropertyName == 'recordcount'	&& Undocumented
			lnPropertyID	= 84
		CASE tcPropertyName == 'undocumented_view_prop_85'	&& Undocumented
			lnPropertyID	= 85
		CASE tcPropertyName == 'dbcevents'	&& Undocumented
			lnPropertyID	= 86
		CASE tcPropertyName == 'dbceventfilename'	&& Undocumented
			lnPropertyID	= 87
		CASE tcPropertyName == 'allowsimultaneousfetch'	&& Undocumented
			lnPropertyID	= 88
		CASE tcPropertyName == 'disconnectrollback'	&& Undocumented
			lnPropertyID	= 89
		OTHERWISE
			IF tlRethrowError
				ERROR 1559, (tcPropertyName)
			ELSE
				lnPropertyID	= -1
			ENDIF
		ENDCASE

		RETURN lnPropertyID
	ENDPROC


	PROCEDURE getDBCPropertyNameByID
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcPropertyID				(v! IN    ) Nombre de la propiedad
		* tlRethrowError			(v? IN    ) Indica si se debe relanzar el error o solo devolver -1
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tnPropertyID, tlRethrowError
		LOCAL lcPropertyName

		DO CASE
		CASE tnPropertyID	= 0
			lcPropertyName = 'null'
		CASE tnPropertyID	= 1
			lcPropertyName = 'path'
		CASE tnPropertyID	= 2
			lcPropertyName = 'class'
		CASE tnPropertyID	= 7
			lcPropertyName = 'comment'
		CASE tnPropertyID	= 9
			lcPropertyName = 'ruleexpression'
		CASE tnPropertyID	= 10
			lcPropertyName = 'ruletext'
		CASE tnPropertyID	= 11
			lcPropertyName = 'defaultvalue'
		CASE tnPropertyID	= 12
			lcPropertyName = 'parameterlist'
		CASE tnPropertyID	= 13
			lcPropertyName = 'childtag'
		CASE tnPropertyID	= 14
			lcPropertyName = 'inserttrigger'
		CASE tnPropertyID	= 15
			lcPropertyName = 'updatetrigger'
		CASE tnPropertyID	= 16
			lcPropertyName = 'deletetrigger'
		CASE tnPropertyID	= 17
			lcPropertyName = 'isunique'
		CASE tnPropertyID	= 18
			lcPropertyName = 'parenttable'
		CASE tnPropertyID	= 19
			lcPropertyName = 'parenttag'
		CASE tnPropertyID	= 20
			lcPropertyName = 'primarykey'
		CASE tnPropertyID	= 24
			lcPropertyName = 'version'
		CASE tnPropertyID	= 28
			lcPropertyName = 'batchupdatecount'
		CASE tnPropertyID	= 29
			lcPropertyName = 'datasource'
		CASE tnPropertyID	= 32
			lcPropertyName = 'connectname'
		CASE tnPropertyID	= 35
			lcPropertyName = 'updatename'
		CASE tnPropertyID	= 36
			lcPropertyName = 'fetchmemo'
		CASE tnPropertyID	= 37
			lcPropertyName = 'fetchsize'
		CASE tnPropertyID	= 38
			lcPropertyName = 'keyfield'
		CASE tnPropertyID	= 39
			lcPropertyName = 'maxrecords'
		CASE tnPropertyID	= 40
			lcPropertyName = 'shareconnection'
		CASE tnPropertyID	= 41
			lcPropertyName = 'sourcetype'
		CASE tnPropertyID	= 42
			lcPropertyName = 'sql'
		CASE tnPropertyID	= 43
			lcPropertyName = 'tables'
		CASE tnPropertyID	= 44
			lcPropertyName = 'sendupdates'
		CASE tnPropertyID	= 45
			lcPropertyName = 'updatablefield'
		CASE tnPropertyID	= 46
			lcPropertyName = 'updatetype'
		CASE tnPropertyID	= 47
			lcPropertyName = 'usememosize'
		CASE tnPropertyID	= 48
			lcPropertyName = 'wheretype'
		CASE tnPropertyID	= 50
			lcPropertyName = 'displayclass'	&& Undocumented
		CASE tnPropertyID	= 51
			lcPropertyName = 'displayclasslibrary'	&& Undocumented
		CASE tnPropertyID	= 54
			lcPropertyName = 'inputmask'	&& Undocumented
		CASE tnPropertyID	= 55
			lcPropertyName = 'format'	&& Undocumented
		CASE tnPropertyID	= 56
			lcPropertyName = 'caption'
		CASE tnPropertyID	= 64
			lcPropertyName = 'asynchronous'
		CASE tnPropertyID	= 65
			lcPropertyName = 'batchmode'
		CASE tnPropertyID	= 66
			lcPropertyName = 'connectstring'
		CASE tnPropertyID	= 67
			lcPropertyName = 'connecttimeout'
		CASE tnPropertyID	= 68
			lcPropertyName = 'displogin'
		CASE tnPropertyID	= 69
			lcPropertyName = 'dispwarnings'
		CASE tnPropertyID	= 70
			lcPropertyName = 'idletimeout'
		CASE tnPropertyID	= 71
			lcPropertyName = 'querytimeout'
		CASE tnPropertyID	= 72
			lcPropertyName = 'password'
		CASE tnPropertyID	= 73
			lcPropertyName = 'transactions'
		CASE tnPropertyID	= 74
			lcPropertyName = 'userid'
		CASE tnPropertyID	= 75
			lcPropertyName = 'waittime'
		CASE tnPropertyID	= 76
			lcPropertyName = 'timestamp'
		CASE tnPropertyID	= 77
			lcPropertyName = 'datatype'
		CASE tnPropertyID	= 78
			lcPropertyName = 'packetsize'	&& Undocumented
		CASE tnPropertyID	= 79
			lcPropertyName = 'database'	&& Undocumented
		CASE tnPropertyID	= 80
			lcPropertyName = 'prepared'	&& Undocumented
		CASE tnPropertyID	= 81
			lcPropertyName = 'comparememo'	&& Undocumented
		CASE tnPropertyID	= 82
			lcPropertyName = 'fetchasneeded'	&& Undocumented
		CASE tnPropertyID	= 83
			lcPropertyName = 'offline'	&& Undocumented
		CASE tnPropertyID	= 84
			lcPropertyName = 'recordcount'	&& Undocumented
		CASE tnPropertyID	= 85
			lcPropertyName = 'undocumented_view_prop_85'	&& Undocumented
		CASE tnPropertyID	= 86
			lcPropertyName = 'dbcevents'	&& Undocumented
		CASE tnPropertyID	= 87
			lcPropertyName = 'dbceventfilename'	&& Undocumented
		CASE tnPropertyID	= 88
			lcPropertyName = 'allowsimultaneousfetch'	&& Undocumented
		CASE tnPropertyID	= 89
			lcPropertyName = 'disconnectrollback'	&& Undocumented
		OTHERWISE
			IF tlRethrowError
				ERROR 1559, (TRANSFORM(tnPropertyID))
			ELSE
				lcPropertyName	= ''
			ENDIF
		ENDCASE

		RETURN lcPropertyName
	ENDPROC


	PROCEDURE getDBCPropertyValueTypeByPropertyID
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tnPropertyID				(v! IN    ) ID de la Propiedad
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tnPropertyID
		LOCAL lcValueType
		lcValueType	= ''

		DO CASE
		CASE INLIST(tnPropertyID,2,41,46,48,68,73)
			lcValueType	= 'B'	&& Byte

		CASE INLIST(tnPropertyID,17,36,38,40,44,45,64,65,69,80,81,82,83,86,88,89)
			lcValueType	= 'L'

		CASE INLIST(tnPropertyID,24,28,37,39,47,67,70,71,75,76,78,84,85)
			lcValueType	= 'N'

		CASE INLIST(tnPropertyID,0,1,7,9,10,11,12,13,14,15,16,18,19,20,29,30,32,35) ;
				OR INLIST(tnPropertyID,42,43,49,50,51,54,55,56,66,67,72,74,77,79,87)
			lcValueType	= 'C'

		OTHERWISE
			ERROR 'Propiedad [' + TRANSFORM(tnPropertyID) + '] no reconocida.'
		ENDCASE

		RETURN lcValueType
	ENDPROC


	PROCEDURE DBGETPROP
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcName					(v! IN    ) Nombre del objeto
		* tcType					(v! IN    ) Tipo de objeto (Table, Index, Field, View, Relation)
		* tcProperty				(v! IN    ) Nombre de la propiedad
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcName, tcType, tcProperty

		TRY
			LOCAL lcValue, leValue, lnSelect, laProperty(1,1), lnRecordLen, lcBinRecord, lnPropertyID ;
				, lnLastPos, lnLenCCode, lcDataType, lnSerchedDataCC, lcDBF, lnLenData, lnLenHeader
			lnSelect	= SELECT()
			leValue		= ''
			tcName		= PROPER(RTRIM(tcName))
			tcType		= PROPER(RTRIM(tcType))
			tcProperty	= PROPER(RTRIM(tcProperty))
			lcDBF		= DBF()

			SELECT 0
			USE (lcDBF) AGAIN SHARED NOUPDATE ALIAS C_TABLABIN2

			IF INLIST( tcType, 'Index', 'Field' )
				SELECT TB.Property FROM C_TABLABIN2 TB ;
					INNER JOIN C_TABLABIN2 TB2 ON STR(TB.ParentID)+TB.ObjectType+LOWER(TB.objectName) = STR(TB2.ObjectID)+PADR(tcType,10)+PADR(LOWER(JUSTEXT(tcName)),128) ;
					AND TB2.objectName = PADR(LOWER(JUSTSTEM(tcName)),128) ;
					INTO ARRAY laProperty

			ELSE
				SELECT TB.Property FROM C_TABLABIN2 TB ;
					INNER JOIN C_TABLABIN2 TB2 ON STR(TB.ParentID)+TB.ObjectType+LOWER(TB.objectName) = STR(TB2.ObjectID)+PADR(tcType,10)+PADR(LOWER(tcName),128) ;
					INTO ARRAY laProperty

			ENDIF

			IF _TALLY > 0
				IF EMPTY(laProperty(1,1))
					EXIT
				ENDIF

				lnLastPos		= 1
				lnSerchedDataCC	= THIS.getDBCPropertyIDByName( tcProperty, .T. )

				DO WHILE lnLastPos < LEN(laProperty(1,1))
					lnRecordLen		= CTOBIN( SUBSTR(laProperty(1,1), lnLastPos, 4), "4RS" )
					lcBinRecord		= SUBSTR(laProperty(1,1), lnLastPos, lnRecordLen)
					lnLenCCode		= CTOBIN( SUBSTR(lcBinRecord, 4+1, 2), "2RS" )
					lnPropertyID	= ASC( SUBSTR(lcBinRecord, 4+2+1, lnLenCCode) )

					IF lnPropertyID = lnSerchedDataCC
						lcDataType		= THIS.getDBCPropertyValueTypeByPropertyID( lnPropertyID )
						lnLenHeader		= 4 + 2 + lnLenCCode
						lcValue			= SUBSTR(lcBinRecord, lnLenHeader + 1)

						DO CASE
						CASE lcDataType = 'B'
							IF lnLenHeader = lnRecordLen
								leValue		= 0
							ELSE
								leValue		= ASC( lcValue )
							ENDIF

						CASE lcDataType = 'L'
							IF lnLenHeader = lnRecordLen
								leValue		= .F.
							ELSE
								leValue		= ( CTOBIN( lcValue, "1S" ) = 1 )
							ENDIF

						CASE lcDataType = 'N'
							IF lnLenHeader = lnRecordLen
								leValue		= 0
							ELSE
								leValue		= CTOBIN( lcValue, "4S" )
							ENDIF

						OTHERWISE && Asume 'C'
							IF lnLenHeader = lnRecordLen
								leValue		= ''
							ELSE
								leValue		= LEFT( lcValue, AT( CHR(0), lcValue ) - 1 )
							ENDIF
						ENDCASE

						EXIT
					ENDIF

					lnLastPos	= lnLastPos + lnRecordLen
				ENDDO
			ELSE
				ERROR 1562, (tcName)
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("C_TABLABIN2"))
			SELECT (lnSelect)
		ENDTRY

		RETURN leValue
	ENDPROC


	PROCEDURE DBSETPROP
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcName					(v! IN    ) Nombre del objeto
		* tcType					(v! IN    ) Tipo de objeto (Table, Index, Field, View, Relation)
		* tcProperty				(v! IN    ) Nombre de la propiedad
		* tePropertyValue			(v! IN    ) Valor de la propiedad
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcName, tcType, tcProperty, tePropertyValue

	ENDPROC


	PROCEDURE getBinPropertyDataRecord
		LPARAMETERS teData, tnPropertyID
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* teData					(v! IN    ) Dato a codificar
		* tnPropertyID				(v! IN    ) ID de la propiedad a la que pertenece
		*---------------------------------------------------------------------------------------------------

		TRY
			LOCAL lcBinRecord, lnLen, lcDataType

			lcBinRecord	= ''
			*lcDataType	= IIF( tnPropertyID = 2, 'B', VARTYPE(teData) )
			lcDataType	= THIS.getDBCPropertyValueTypeByPropertyID( tnPropertyID )

			DO CASE
			CASE lcDataType = 'B'
				teData			= CHR(teData)
				lnLen			= 4 + 2 + 1 + 1
				lcBinRecord		= BINTOC( lnLen, "4RS" ) + BINTOC( 1, "2RS" ) + CHR(tnPropertyID) + teData

			CASE lcDataType = 'L'
				teData			= BINTOC( IIF(teData,1,0), "1S" )
				lnLen			= 4 + 2 + 1 + 1
				lcBinRecord		= BINTOC( lnLen, "4RS" ) + BINTOC( 1, "2RS" ) + CHR(tnPropertyID) + teData

			CASE lcDataType = 'N'
				teData			= BINTOC( teData, "4S" )
				lnLen			= 4 + 2 + 1 + 4
				lcBinRecord		= BINTOC( lnLen, "4RS" ) + BINTOC( 1, "2RS" ) + CHR(tnPropertyID) + teData

			OTHERWISE	&& Asume 'C'
				IF EMPTY(teData)
					EXIT
				ENDIF
				lnLen			= 4 + 2 + 1 + LEN(teData) + 1
				lcBinRecord		= BINTOC( lnLen, "4RS" ) + BINTOC( 1, "2RS" ) + CHR(tnPropertyID) + teData + CHR(0)

			ENDCASE


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcBinRecord
	ENDPROC


	PROCEDURE getID
		RETURN THIS.__ObjectID
	ENDPROC


	PROCEDURE getCodeMemo
		RETURN ''
	ENDPROC


	PROCEDURE getUserMemo
		RETURN ''
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		RETURN ''
	ENDPROC


	PROCEDURE getReferentialIntegrityInfo
		RETURN ''
	ENDPROC


	PROCEDURE getObjectType
		LOCAL lcType

		DO CASE
		CASE THIS.CLASS == 'Cl_dbc'
			lcType	= 'Database'

		CASE THIS.CLASS == 'Cl_dbc_connection'
			lcType	= 'Connection'

		CASE THIS.CLASS == 'Cl_dbc_table'
			lcType	= 'Table'

		CASE THIS.CLASS == 'Cl_dbc_view'
			lcType	= 'View'

		CASE THIS.CLASS == 'Cl_dbc_index_db' OR THIS.CLASS == 'Cl_dbc_index_vw'
			lcType	= 'Index'

		CASE THIS.CLASS == 'Cl_dbc_relation'
			lcType	= 'Relation'

		CASE THIS.CLASS == 'Cl_dbc_field_db' OR THIS.CLASS == 'Cl_dbc_field_vw'
			lcType	= 'Field'

		OTHERWISE
			ERROR 'Clase [' + THIS.CLASS + '] desconocida'

		ENDCASE

		RETURN lcType
	ENDPROC


	PROCEDURE setNextID
		LPARAMETERS tnLastID
		tnLastID	= tnLastID + 1
		THIS.__ObjectID	= tnLastID
	ENDPROC


	PROCEDURE updateDBC
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFile				(v! IN    ) Nombre del archivo de salida
		* tnLastID					(@! IN    ) �ltimo n�mero de ID usado
		* tnParentID				(v! IN    ) ID del objeto Padre
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_OutputFile, tnLastID, tnParentID

		TRY
			LOCAL lcMemoWithProperties, lcCodeMemo, lcObjectType, lcRI_Info, lcUserMemo, lcID

			WITH THIS AS CL_DBC_BASE OF 'FOXBIN2PRG.PRG'
				.setNextID( @tnLastID )
				lcMemoWithProperties	= .getBinMemoFromProperties()
				lcCodeMemo				= .getCodeMemo()
				lcObjectType			= .getObjectType()
				lcRI_Info				= .getReferentialIntegrityInfo()
				lcUserMemo				= .getUserMemo()
				lcID					= .getID()

				INSERT INTO TABLABIN ;
					( ObjectID ;
					, ParentID ;
					, ObjectType ;
					, objectName ;
					, Property ;
					, CODE ;
					, RIInfo ;
					, USER ) ;
					VALUES ;
					( lcID ;
					, tnParentID ;
					, lcObjectType ;
					, LOWER(._Name) ;
					, lcMemoWithProperties ;
					, lcCodeMemo ;
					, lcRI_Info ;
					, lcUserMemo )
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_sp" display="analizarBloque_SP"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [<memberdata name="_dbcevents" display="_DBCEvents"/>] ;
		+ [<memberdata name="_dbceventfilename" display="_DBCEventFilename"/>] ;
		+ [<memberdata name="_connections" display="_Connections"/>] ;
		+ [<memberdata name="_tables" display="_Tables"/>] ;
		+ [<memberdata name="_views" display="_Views"/>] ;
		+ [<memberdata name="_relations" display="_Relations"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [<memberdata name="_storedprocedures" display="_StoredProcedures"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [</VFPData>]


	*-- Modulo
	_Version			= 0
	_SourceFile			= ''

	*-- Database Info
	_Name				= ''
	_Comment			= ''
	_Version			= 0
	_DBCEvents			= .F.
	_DBCEventFilename	= ''
	_StoredProcedures	= ''


	PROCEDURE INIT
		DODEFAULT()
		*--
		THIS.ADDOBJECT("_Connections", "CL_DBC_CONNECTIONS")
		THIS.ADDOBJECT("_Tables", "CL_DBC_TABLES")
		THIS.ADDOBJECT("_Views", "CL_DBC_VIEWS")
	ENDPROC


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loConnections AS CL_DBC_CONNECTIONS OF 'FOXBIN2PRG.PRG'
			LOCAL loTables AS CL_DBC_TABLES OF 'FOXBIN2PRG.PRG'
			LOCAL loViews AS CL_DBC_VIEWS OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_DATABASE_I)) == C_DATABASE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_DATABASE_F $ tcLine	&& Fin
						EXIT

					CASE C_CONNECTIONS_I $ tcLine
						loConnections	= THIS._Connections
						loConnections.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_TABLES_I $ tcLine
						loTables	= THIS._Tables
						loTables.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_VIEWS_I $ tcLine
						loViews	= THIS._Views
						loViews.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_STORED_PROC_I $ tcLine
						THIS.analizarBloque_SP( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Otro valor
						*-- Estructura a reconocer:
						* 	<tagname>ID<tagname>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_SP
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		IF LEFT(tcLine, LEN(C_STORED_PROC_I)) == C_STORED_PROC_I
			LOCAL lcValue
			lcValue	= ''
			llBloqueEncontrado	= .T.

			FOR I = I + 1 TO tnCodeLines
				THIS.set_Line( @tcLine, @taCodeLines, I )

				DO CASE
				CASE C_STORED_PROC_F $ tcLine	&& Fin
					EXIT

				OTHERWISE	&& L�nea de Stored Procedure
					lcValue	= lcValue + CR_LF + taCodeLines(I)
				ENDCASE
			ENDFOR

			THIS.ADDPROPERTY( '_StoredProcedures', SUBSTR(lcValue,3) )
		ENDIF
	ENDPROC


	PROCEDURE updateDBC
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFile				(v! IN    ) Nombre del archivo de salida
		* tnLastID					(@! IN    ) �ltimo n�mero de ID usado
		* tnParentID				(v! IN    ) ID del objeto Padre
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_OutputFile, tnLastID, tnParentID

		TRY
			LOCAL loTables AS CL_DBC_TABLES OF 'FOXBIN2PRG.PRG'
			LOCAL loConnections AS CL_DBC_CONNECTIONS OF 'FOXBIN2PRG.PRG'
			LOCAL loViews AS CL_DBC_VIEWS OF 'FOXBIN2PRG.PRG'

			loTables		= THIS._Tables
			loConnections	= THIS._Connections
			loViews			= THIS._Views

			CREATE DATABASE (tc_OutputFile)
			CLOSE DATABASES
			OPEN DATABASE (tc_OutputFile) SHARED
			USE (tc_OutputFile) SHARED AGAIN ALIAS TABLABIN
			tnLastID	= 5
			THIS.setNextID(0)
			tnParentID	= THIS.__ObjectID

			lcMemoWithProperties	= THIS.getBinMemoFromProperties()
			UPDATE TABLABIN ;
				SET Property = lcMemoWithProperties ;
				WHERE STR(ParentID) + ObjectType + LOWER(objectName) = STR(1) + PADR('Database',10) + PADR(LOWER('Database'),128)

			IF NOT EMPTY(THIS._StoredProcedures)
				UPDATE TABLABIN ;
					SET CODE = THIS._StoredProcedures ;
					WHERE STR(ParentID) + ObjectType + LOWER(objectName) = STR(1) + PADR('Database',10) + PADR(LOWER('StoredProceduresSource'),128)
			ENDIF

			loTables.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
			loViews.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
			loConnections.updateDBC( tc_OutputFile, @tnLastID, tnParentID )


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			CLOSE DATABASES
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE toText
		TRY
			LOCAL I, lcText, lcDBC, laCode(1,1), loEx AS EXCEPTION
			LOCAL loConnections AS CL_DBC_CONNECTIONS OF 'FOXBIN2PRG.PRG'
			LOCAL loTables AS CL_DBC_TABLES OF 'FOXBIN2PRG.PRG'
			LOCAL loViews AS CL_DBC_VIEWS OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<DATABASE>
				<<>>	<Name><<lcDBC>></Name>
				<<>>	<Comment><<DBGETPROP(lcDBC,"DATABASE","Comment")>></Comment>
				<<>>	<Version><<DBGETPROP(lcDBC,"DATABASE","Version")>></Version>
				<<>>	<DBCEvents><<DBGETPROP(lcDBC,"DATABASE","DBCEvents")>></DBCEvents>
				<<>>	<DBCEventFilename><<DBGETPROP(lcDBC,"DATABASE","DBCEventFilename")>></DBCEventFilename>
			ENDTEXT

			*-- Connections
			loConnections	= THIS._Connections
			lcText			= lcText + loConnections.toText()

			*-- Tables
			loTables		= THIS._Tables
			lcText			= lcText + loTables.toText()

			*-- Views
			loViews			= THIS._Views
			lcText			= lcText + loViews.toText()

			SELECT CODE ;
				FROM TABLABIN ;
				WHERE STR(ParentID) + ObjectType + LOWER(objectName) = STR(1) + PADR('Database',10) + PADR(LOWER('StoredProceduresSource'),128) ;
				INTO ARRAY laCode
			THIS._StoredProcedures	= laCode(1,1)

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<>>	<<C_STORED_PROC_I>>
				<<THIS._StoredProcedures>>
				<<>>	<<C_STORED_PROC_F>>
				</DATABASE>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Version, .getDBCPropertyIDByName('Version', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DBCEvents, .getDBCPropertyIDByName('DBCEvents', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DBCEventFilename, .getDBCPropertyIDByName('DBCEventFilename', .T.) )
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_CONNECTIONS AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_CONNECTIONS OF 'FOXBIN2PRG.PRG'
	#ENDIF


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loConnection AS CL_DBC_CONNECTION OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_CONNECTIONS_I)) == C_CONNECTIONS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_CONNECTIONS_F $ tcLine	&& Fin
						EXIT

					CASE C_CONNECTION_I $ tcLine
						loConnection = CREATEOBJECT("CL_DBC_CONNECTION")
						loConnection.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loConnection, loConnection._Name )

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taConnections				(@?    OUT) Array de conexiones
		* tnConnection_Count		(@?    OUT) Cantidad de conexiones
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taConnections, tnConnection_Count

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			LOCAL loConnection AS CL_DBC_CONNECTION OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			DIMENSION taConnections(1)
			tnConnection_Count	= ADBOBJECTS( taConnections,"CONNECTION" )

			IF tnConnection_Count > 0
				ASORT( taConnections, 1, -1, 0, 1 )

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>	<CONNECTIONS>
				ENDTEXT

				loConnection	= CREATEOBJECT('CL_DBC_CONNECTION')

				FOR I = 1 TO tnConnection_Count
					lcText	= lcText + loConnection.toText( taConnections(I) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	</CONNECTIONS>
					<<>>
				ENDTEXT
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_CONNECTION AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_CONNECTION OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_datasource" display="_DataSource"/>] ;
		+ [<memberdata name="_database" display="_Database"/>] ;
		+ [<memberdata name="_connectstring" display="_ConnectString"/>] ;
		+ [<memberdata name="_asynchronous" display="_Asynchronous"/>] ;
		+ [<memberdata name="_batchmode" display="_BatchMode"/>] ;
		+ [<memberdata name="_connecttimeout" display="_ConnectTimeout"/>] ;
		+ [<memberdata name="_disconnectrollback" display="_DisconnectRollback"/>] ;
		+ [<memberdata name="_displogin" display="_DispLogin"/>] ;
		+ [<memberdata name="_dispwarnings" display="_DispWarnings"/>] ;
		+ [<memberdata name="_idletimeout" display="_IdleTimeout"/>] ;
		+ [<memberdata name="_packetsize" display="_PacketSize"/>] ;
		+ [<memberdata name="_password" display="_PassWord"/>] ;
		+ [<memberdata name="_querytimeout" display="_QueryTimeout"/>] ;
		+ [<memberdata name="_transactions" display="_Transactions"/>] ;
		+ [<memberdata name="_userid" display="_UserId"/>] ;
		+ [<memberdata name="_waittime" display="_WaitTime"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_Comment				= ''
	_DataSource				= ''
	_Database				= ''
	_ConnectString			= ''
	_Asynchronous			= .F.
	_BatchMode				= .F.
	_ConnectTimeout			= 0
	_DisconnectRollback		= .F.
	_DispLogin				= 0
	_DispWarnings			= .F.
	_IdleTimeout			= 0
	_PacketSize				= 0
	_PassWord				= ''
	_QueryTimeout			= 0
	_Transactions			= ''
	_UserId					= ''
	_WaitTime				= 0


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_CONNECTION_I)) == C_CONNECTION_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_CONNECTION_F $ tcLine	&& Fin
						EXIT

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de CONNECTION
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcConnection				(v! IN    ) Nombre de la Conexi�n
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcConnection

		TRY
			LOCAL lcText, loEx AS EXCEPTION

			TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>		<CONNECTION>
				<<>>			<Name><<tcConnection>></Name>
				<<>>			<Comment><<DBGETPROP(tcConnection,"CONNECTION","Comment")>></Comment>
				<<>>			<DataSource><<DBGETPROP(tcConnection,"CONNECTION","DataSource")>></DataSource>
				<<>>			<Database><<DBGETPROP(tcConnection,"CONNECTION","Database")>></Database>
				<<>>			<ConnectString><<DBGETPROP(tcConnection,"CONNECTION","ConnectString")>></ConnectString>
				<<>>			<Asynchronous><<DBGETPROP(tcConnection,"CONNECTION","Asynchronous")>></Asynchronous>
				<<>>			<BatchMode><<DBGETPROP(tcConnection,"CONNECTION","BatchMode")>></BatchMode>
				<<>>			<ConnectTimeout><<DBGETPROP(tcConnection,"CONNECTION","ConnectTimeout")>></ConnectTimeout>
				<<>>			<DisconnectRollback><<DBGETPROP(tcConnection,"CONNECTION","DisconnectRollback")>></DisconnectRollback>
				<<>>			<DispLogin><<DBGETPROP(tcConnection,"CONNECTION","DispLogin")>></DispLogin>
				<<>>			<DispWarnings><<DBGETPROP(tcConnection,"CONNECTION","DispWarnings")>></DispWarnings>
				<<>>			<IdleTimeout><<DBGETPROP(tcConnection,"CONNECTION","IdleTimeout")>></IdleTimeout>
				<<>>			<PacketSize><<DBGETPROP(tcConnection,"CONNECTION","PacketSize")>></PacketSize>
				<<>>			<PassWord><<DBGETPROP(tcConnection,"CONNECTION","PassWord")>></PassWord>
				<<>>			<QueryTimeout><<DBGETPROP(tcConnection,"CONNECTION","QueryTimeout")>></QueryTimeout>
				<<>>			<Transactions><<DBGETPROP(tcConnection,"CONNECTION","Transactions")>></Transactions>
				<<>>			<UserId><<DBGETPROP(tcConnection,"CONNECTION","UserId")>></UserId>
				<<>>			<WaitTime><<DBGETPROP(tcConnection,"CONNECTION","WaitTime")>></WaitTime>
				<<>>		</CONNECTION>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_CONNECTION OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Asynchronous, .getDBCPropertyIDByName('Asynchronous', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._BatchMode, .getDBCPropertyIDByName('BatchMode', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DispWarnings, .getDBCPropertyIDByName('DispWarnings') )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DispLogin, .getDBCPropertyIDByName('DispLogin', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Transactions, .getDBCPropertyIDByName('Transactions', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DisconnectRollback, .getDBCPropertyIDByName('DisconnectRollback', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ConnectTimeout , .getDBCPropertyIDByName('ConnectTimeout', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._QueryTimeout, .getDBCPropertyIDByName('QueryTimeout', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._IdleTimeout, .getDBCPropertyIDByName('IdleTimeout', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._WaitTime, .getDBCPropertyIDByName('WaitTime', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._PacketSize, .getDBCPropertyIDByName('PacketSize', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DataSource, .getDBCPropertyIDByName('DataSource', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._UserId, .getDBCPropertyIDByName('UserId', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._PassWord, .getDBCPropertyIDByName('PassWord', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Database, .getDBCPropertyIDByName('Database', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ConnectString, .getDBCPropertyIDByName('ConnectString', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
		ENDWITH

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_TABLES AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_TABLES OF 'FOXBIN2PRG.PRG'
	#ENDIF


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loTable AS CL_DBC_TABLE OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_TABLES_I)) == C_TABLES_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_TABLES_F $ tcLine	&& Fin
						EXIT

					CASE C_TABLE_I $ tcLine
						loTable = CREATEOBJECT("CL_DBC_TABLE")
						loTable.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loTable, loTable._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taTables					(@?    OUT) Array de conexiones
		* lnTable_Count				(@?    OUT) Cantidad de conexiones
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taTables, tnTable_Count

		EXTERNAL ARRAY taTables

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			LOCAL loTable AS CL_DBC_TABLE OF 'FOXBIN2PRG.PRG'
			STORE 0 TO I, tnTable_Count
			lcText	= ''

			DIMENSION taTables(1)
			tnTable_Count	= ADBOBJECTS( taTables,"TABLE" )

			IF tnTable_Count > 0
				ASORT( taTables, 1, -1, 0, 1 )

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>	<TABLES>
				ENDTEXT

				loTable	= CREATEOBJECT('CL_DBC_TABLE')

				FOR I = 1 TO tnTable_Count
					lcText	= lcText + loTable.toText( taTables(I) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	</TABLES>
					<<>>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF BETWEEN(I, 1, tnTable_Count)
				loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "taTables(" + TRANSFORM(I) + ") = " + RTRIM(TRANSFORM(taTables(I)))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_TABLE AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_TABLE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_path" display="_Path"/>] ;
		+ [<memberdata name="_deletetrigger" display="_DeleteTrigger"/>] ;
		+ [<memberdata name="_inserttrigger" display="_InsertTrigger"/>] ;
		+ [<memberdata name="_updatetrigger" display="_UpdateTrigger"/>] ;
		+ [<memberdata name="_primarykey" display="_PrimaryKey"/>] ;
		+ [<memberdata name="_ruleexpression" display="_RuleExpression"/>] ;
		+ [<memberdata name="_ruletext" display="_RuleText"/>] ;
		+ [<memberdata name="_fields" display="_Fields"/>] ;
		+ [<memberdata name="_indexes" display="_Indexes"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_Comment				= ''
	_Path					= ''
	_DeleteTrigger			= ''
	_InsertTrigger			= ''
	_UpdateTrigger			= ''
	_PrimaryKey				= ''
	_RuleExpression			= ''
	_RuleText				= ''

	*-- Sub-objects
	*_Fields					= NULL
	*_Indexes					= NULL


	PROCEDURE INIT
		DODEFAULT()
		*--
		THIS.ADDOBJECT("_Fields", "CL_DBC_FIELDS_DB")
		THIS.ADDOBJECT("_Indexes", "CL_DBC_INDEXES_DB")
		THIS.ADDOBJECT("_Relations", "CL_DBC_RELATIONS")
	ENDPROC


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			LOCAL loFields AS CL_DBC_FIELDS_DB OF 'FOXBIN2PRG.PRG'
			LOCAL loIndexes AS CL_DBC_INDEXES_DB OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_TABLE_I)) == C_TABLE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_TABLE_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELDS_I $ tcLine
						loFields = THIS._Fields
						loFields.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_INDEXES_I $ tcLine
						loIndexes = THIS._Indexes
						loIndexes.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_RELATIONS_I $ tcLine
						loRelations	= THIS._Relations
						loRelations.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de TABLE
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcTable					(v! IN    ) Nombre de la Tabla
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcTable

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			LOCAL loIndexes AS CL_DBC_INDEXES_DB OF 'FOXBIN2PRG.PRG'
			LOCAL loFields AS CL_DBC_FIELDS_DB OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<>>		<TABLE>
				<<>>			<Name><<tcTable>></Name>
				<<>>			<Comment><<DBGETPROP(tcTable,"TABLE","Comment")>></Comment>
				<<>>			<Path><<DBGETPROP(tcTable,"TABLE","Path")>></Path>
				<<>>			<DeleteTrigger><<DBGETPROP(tcTable,"TABLE","DeleteTrigger")>></DeleteTrigger>
				<<>>			<InsertTrigger><<DBGETPROP(tcTable,"TABLE","InsertTrigger")>></InsertTrigger>
				<<>>			<UpdateTrigger><<DBGETPROP(tcTable,"TABLE","UpdateTrigger")>></UpdateTrigger>
				<<>>			<PrimaryKey><<DBGETPROP(tcTable,"TABLE","PrimaryKey")>></PrimaryKey>
				<<>>			<RuleExpression><<DBGETPROP(tcTable,"TABLE","RuleExpression")>></RuleExpression>
				<<>>			<RuleText><<DBGETPROP(tcTable,"TABLE","RuleText")>></RuleText>
			ENDTEXT

			loFields	= CREATEOBJECT('CL_DBC_FIELDS_DB')
			lcText		= lcText + loFields.toText( tcTable )

			loIndexes	= CREATEOBJECT('CL_DBC_INDEXES_DB')
			lcText		= lcText + loIndexes.toText( tcTable )

			loRelations	= CREATEOBJECT('CL_DBC_RELATIONS')
			lcText		= lcText + loRelations.toText( tcTable )

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>		</TABLE>
			ENDTEXT


		CATCH TO loEx
			loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcTable = " + RTRIM(TRANSFORM(tcTable))

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE updateDBC
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFile				(v! IN    ) Nombre del archivo de salida
		* tnLastID					(@! IN    ) �ltimo n�mero de ID usado
		* tnParentID				(v! IN    ) ID del objeto Padre
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_OutputFile, tnLastID, tnParentID

		DODEFAULT( tc_OutputFile, @tnLastID, tnParentID)
		tnParentID	= THIS.__ObjectID
		THIS._Fields.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
		THIS._Indexes.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
		THIS._Relations.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_TABLE OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( 1, .getDBCPropertyIDByName('Class', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Path, .getDBCPropertyIDByName('Path', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._PrimaryKey, .getDBCPropertyIDByName('PrimaryKey', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleExpression, .getDBCPropertyIDByName('RuleExpression', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleText, .getDBCPropertyIDByName('RuleText', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._InsertTrigger, .getDBCPropertyIDByName('InsertTrigger', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._UpdateTrigger, .getDBCPropertyIDByName('UpdateTrigger', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DeleteTrigger, .getDBCPropertyIDByName('DeleteTrigger', .T.) )
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_FIELDS_DB AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_FIELDS_DB OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loField AS CL_DBC_FIELD_DB OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELDS_I)) == C_FIELDS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELDS_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELD_I $ tcLine
						loField = CREATEOBJECT("CL_DBC_FIELD_DB")
						loField.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loField, loField._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcTable					(v! IN    ) Nombre de la Tabla
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcTable

		TRY
			LOCAL X, lcText, lnField_Count, laFields(1), loEx AS EXCEPTION
			LOCAL loField AS CL_DBC_FIELD_DB OF 'FOXBIN2PRG.PRG'
			STORE 0 TO X, lnField_Count
			lcText	= ''

			_TALLY	= 0
			SELECT LOWER(TB.objectName) FROM TABLABIN TB ;
				INNER JOIN TABLABIN TB2 ON STR(TB.ParentID)+TB.ObjectType = STR(TB2.ObjectID)+PADR('Field',10) ;
				AND TB2.objectName = PADR(LOWER(tcTable),128) ;
				INTO ARRAY laFields
			lnField_Count	= _TALLY

			IF lnField_Count > 0
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>			<FIELDS>
				ENDTEXT

				loField	= CREATEOBJECT('CL_DBC_FIELD_DB')

				FOR X = 1 TO lnField_Count
					lcText	= lcText + loField.toText( tcTable, laFields(X) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>			</FIELDS>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF BETWEEN(X, 1, lnField_Count)
				loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcTable = " + RTRIM(TRANSFORM(tcTable)) + ", laFields(" + TRANSFORM(X) + ") = " + RTRIM(TRANSFORM(laFields(X)))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TB"))
			USE IN (SELECT("TB2"))
		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_FIELD_DB AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_FIELD_DB OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_caption" display="_Caption"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_defaultvalue" display="_DefaultValue"/>] ;
		+ [<memberdata name="_displayclass" display="_DisplayClass"/>] ;
		+ [<memberdata name="_displayclasslibrary" display="_DisplayClassLibrary"/>] ;
		+ [<memberdata name="_format" display="_Format"/>] ;
		+ [<memberdata name="_inputmask" display="_InputMask"/>] ;
		+ [<memberdata name="_ruleexpression" display="_RuleExpression"/>] ;
		+ [<memberdata name="_ruletext" display="_RuleText"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_Caption				= ''
	_Comment				= ''
	_DefaultValue			= ''
	_DisplayClass			= ''
	_DisplayClassLibrary	= ''
	_Format					= ''
	_InputMask				= ''
	_RuleExpression			= ''
	_RuleText				= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELD_I)) == C_FIELD_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELD_F $ tcLine	&& Fin
						EXIT

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de FIELD
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcTable					(v! IN    ) Nombre de la Tabla
		* tcField					(v! IN    ) Nombre del campo
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcTable, tcField

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>				<FIELD>
				<<>>					<Name><<RTRIM(tcField)>></Name>
				<<>>					<Caption><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","Caption")>></Caption>
				<<>>					<Comment><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","Comment")>></Comment>
				<<>>					<DefaultValue><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","DefaultValue")>></DefaultValue>
				<<>>					<DisplayClass><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","DisplayClass")>></DisplayClass>
				<<>>					<DisplayClassLibrary><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","DisplayClassLibrary")>></DisplayClassLibrary>
				<<>>					<Format><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","Format")>></Format>
				<<>>					<InputMask><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","InputMask")>></InputMask>
				<<>>					<RuleExpression><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","RuleExpression")>></RuleExpression>
				<<>>					<RuleText><<DBGETPROP( RTRIM(tcTable) + '.' + RTRIM(tcField),"FIELD","RuleText")>></RuleText>
				<<>>				</FIELD>
			ENDTEXT


		CATCH TO loEx
			loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcTable = " + RTRIM(TRANSFORM(tcTable)) + ", tcField = " + RTRIM(TRANSFORM(tcField))

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_FIELD_DB OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DefaultValue, .getDBCPropertyIDByName('DefaultValue', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DisplayClass, .getDBCPropertyIDByName('DisplayClass', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DisplayClassLibrary, .getDBCPropertyIDByName('DisplayClassLibrary', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Caption, .getDBCPropertyIDByName('Caption', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Format, .getDBCPropertyIDByName('Format', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._InputMask, .getDBCPropertyIDByName('InputMask', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleExpression, .getDBCPropertyIDByName('RuleExpression', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleText, .getDBCPropertyIDByName('RuleText', .T.) )
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_INDEXES_DB AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_INDEXES_DB OF 'FOXBIN2PRG.PRG'
	#ENDIF


	*-- Info
	_Name					= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loIndex AS CL_DBC_INDEX_DB OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_INDEXES_I)) == C_INDEXES_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_INDEXES_F $ tcLine	&& Fin
						EXIT

					CASE C_INDEX_I $ tcLine
						loIndex = CREATEOBJECT("CL_DBC_INDEX_DB")
						loIndex.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loIndex, loIndex._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcTable					(v! IN    ) Nombre de la Tabla
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcTable

		TRY
			LOCAL X, lcText, lnIndex_Count, laIndexes(1), loEx AS EXCEPTION
			LOCAL loIndex AS CL_DBC_INDEX_DB OF 'FOXBIN2PRG.PRG'
			STORE 0 TO X, lnIndex_Count
			lcText	= ''

			_TALLY	= 0
			SELECT LOWER(TB.objectName) FROM TABLABIN TB ;
				INNER JOIN TABLABIN TB2 ON STR(TB.ParentID)+TB.ObjectType = STR(TB2.ObjectID)+PADR('Index',10) ;
				AND TB2.objectName = PADR(LOWER(tcTable),128) ;
				INTO ARRAY laIndexes
			lnIndex_Count	= _TALLY

			IF lnIndex_Count > 0
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>			<INDEXES>
				ENDTEXT

				loIndex	= CREATEOBJECT('CL_DBC_INDEX_DB')

				FOR X = 1 TO lnIndex_Count
					lcText	= lcText + loIndex.toText( tcTable + '.' + laIndexes(X) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>			</INDEXES>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF BETWEEN(X, 1, lnField_Count)
				loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "laIndexes(" + TRANSFORM(X) + ") = " + RTRIM(laIndexes(X))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TB"))
			USE IN (SELECT("TB2"))
		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_INDEX_DB AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_INDEX_DB OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_isunique" display="_IsUnique"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_IsUnique				= .F.
	_Comment				= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_INDEX_I)) == C_INDEX_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_INDEX_F $ tcLine	&& Fin
						EXIT

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de FIELD
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcIndex					(v! IN    ) Nombre del �ndice en la forma "tabla.indice"
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcIndex

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>				<INDEX>
				<<>>					<Name><<RTRIM(JUSTEXT(tcIndex))>></Name>
				<<>>					<Comment><<RTRIM( THIS.DBGETPROP(tcIndex,'Index','Comment') )>></Comment>
				<<>>					<IsUnique><<THIS.DBGETPROP(tcIndex,'Index','IsUnique')>></IsUnique>
				<<>>				</INDEX>
			ENDTEXT

		CATCH TO loEx
			loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcIndex = " + RTRIM(TRANSFORM(tcIndex))

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_INDEX_DB OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._IsUnique, .getDBCPropertyIDByName('IsUnique', .T.) )
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_INDEXES_VW AS CL_DBC_INDEXES_DB
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_INDEX_VW AS CL_DBC_INDEX_DB
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_VIEWS AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_VIEWS OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loView AS CL_DBC_VIEW OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_VIEWS_I)) == C_VIEWS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_VIEWS_F $ tcLine	&& Fin
						EXIT

					CASE C_VIEW_I $ tcLine
						loView = CREATEOBJECT("CL_DBC_VIEW")
						loView.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loView, loView._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taViews					(@?    OUT) Array de vistas
		* tnView_Count				(@?    OUT) Cantidad de vistas
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taViews, tnView_Count

		EXTERNAL ARRAY taViews

		TRY
			LOCAL I, lcText, lcDBC, lnField_Count, laFields(1), loEx AS EXCEPTION
			LOCAL loView AS CL_DBC_VIEW OF 'FOXBIN2PRG.PRG'
			STORE 0 TO I, X, tnView_Count, lnField_Count
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			DIMENSION taViews(1)
			tnView_Count	= ADBOBJECTS( taViews,"VIEW" )

			IF tnView_Count > 0
				ASORT( taViews, 1, -1, 0, 1 )

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>	<VIEWS>
				ENDTEXT

				loView	= CREATEOBJECT('CL_DBC_VIEW')

				FOR I = 1 TO tnView_Count
					lcText	= lcText + loView.toText( taViews(I) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	</VIEWS>
					<<>>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF BETWEEN(I, 1, tnTable_Count)
				loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "taViews(" + TRANSFORM(I) + ") = " + RTRIM(taViews(I))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_VIEW AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_VIEW OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_tables" display="_Tables"/>] ;
		+ [<memberdata name="_sql" display="_SQL"/>] ;
		+ [<memberdata name="_allowsimultaneousfetch" display="_AllowSimultaneousFetch"/>] ;
		+ [<memberdata name="_batchupdatecount" display="_BatchUpdateCount"/>] ;
		+ [<memberdata name="_comparememo" display="_CompareMemo"/>] ;
		+ [<memberdata name="_connectname" display="_ConnectName"/>] ;
		+ [<memberdata name="_fetchasneeded" display="_FetchAsNeeded"/>] ;
		+ [<memberdata name="_fetchmemo" display="_FetchMemo"/>] ;
		+ [<memberdata name="_fetchsize" display="_FetchSize"/>] ;
		+ [<memberdata name="_maxrecords" display="_MaxRecords"/>] ;
		+ [<memberdata name="_offline" display="_Offline"/>] ;
		+ [<memberdata name="_recordcount" display="_RecordCount"/>] ;
		+ [<memberdata name="_path" display="_Path"/>] ;
		+ [<memberdata name="_parameterlist" display="_ParameterList"/>] ;
		+ [<memberdata name="_prepared" display="_Prepared"/>] ;
		+ [<memberdata name="_ruleexpression" display="_RuleExpression"/>] ;
		+ [<memberdata name="_ruletext" display="_RuleText"/>] ;
		+ [<memberdata name="_sendupdates" display="_SendUpdates"/>] ;
		+ [<memberdata name="_shareconnection" display="_ShareConnection"/>] ;
		+ [<memberdata name="_sourcetype" display="_SourceType"/>] ;
		+ [<memberdata name="_updatetype" display="_UpdateType"/>] ;
		+ [<memberdata name="_usememosize" display="_UseMemoSize"/>] ;
		+ [<memberdata name="_wheretype" display="_WhereType"/>] ;
		+ [<memberdata name="_fields" display="_Fields"/>] ;
		+ [<memberdata name="_indexes" display="_Indexes"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_Comment				= ''
	_Tables					= ''
	_SQL					= ''
	_AllowSimultaneousFetch	= .F.
	_BatchUpdateCount		= 0
	_CompareMemo			= .F.
	_ConnectName			= ''
	_FetchAsNeeded			= .F.
	_FetchMemo				= .F.
	_FetchSize				= 0
	_MaxRecords				= 0
	_Offline				= .F.
	_RecordCount			= 0
	_Path					= ''
	_ParameterList			= ''
	_Prepared				= .F.
	_RuleExpression			= ''
	_RuleText				= ''
	_SendUpdates			= .F.
	_ShareConnection		= .F.
	_SourceType				= 0
	_UpdateType				= 0
	_UseMemoSize			= 0
	_WhereType				= 0

	*-- Sub-objects
	*_Fields					= NULL
	*_Indexes				= NULL


	PROCEDURE INIT
		DODEFAULT()
		*--
		THIS.ADDOBJECT("_Fields", "CL_DBC_FIELDS_VW")
		THIS.ADDOBJECT("_Indexes", "CL_DBC_INDEXES_VW")
		THIS.ADDOBJECT("_Relations", "CL_DBC_RELATIONS")
	ENDPROC


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			LOCAL loFields AS CL_DBC_FIELDS_VW OF 'FOXBIN2PRG.PRG'
			LOCAL loIndexes AS CL_DBC_INDEXES_VW OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_VIEW_I)) == C_VIEW_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_VIEW_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELDS_I $ tcLine
						loFields	= THIS._Fields
						loFields.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_INDEXES_I $ tcLine
						loIndexes	= THIS._Indexes
						loIndexes.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_RELATIONS_I $ tcLine
						loRelations	= THIS._Relations
						loRelations.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de VIEW
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcView					(v! IN    ) Vista en evaluaci�n
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcView

		TRY
			LOCAL I, lcText, lcDBC, lnField_Count, laFields(1), loEx AS EXCEPTION
			LOCAL loFields AS CL_DBC_FIELDS_VW OF 'FOXBIN2PRG.PRG'
			LOCAL loIndexes AS CL_DBC_INDEXES_VW OF 'FOXBIN2PRG.PRG'
			LOCAL loRelations AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<>>		<VIEW>
				<<>>			<Name><<tcView>></Name>
				<<>>			<Comment><<DBGETPROP(tcView,"VIEW","Comment")>></Comment>
				<<>>			<Tables><<DBGETPROP(tcView,"VIEW","Tables")>></Tables>
				<<>>			<SQL><<DBGETPROP(tcView,"VIEW","SQL")>></SQL>
				<<>>			<AllowSimultaneousFetch><<DBGETPROP(tcView,"VIEW","AllowSimultaneousFetch")>></AllowSimultaneousFetch>
				<<>>			<BatchUpdateCount><<DBGETPROP(tcView,"VIEW","BatchUpdateCount")>></BatchUpdateCount>
				<<>>			<CompareMemo><<DBGETPROP(tcView,"VIEW","CompareMemo")>></CompareMemo>
				<<>>			<ConnectName><<DBGETPROP(tcView,"VIEW","ConnectName")>></ConnectName>
				<<>>			<FetchAsNeeded><<DBGETPROP(tcView,"VIEW","FetchAsNeeded")>></FetchAsNeeded>
				<<>>			<FetchMemo><<DBGETPROP(tcView,"VIEW","FetchMemo")>></FetchMemo>
				<<>>			<FetchSize><<DBGETPROP(tcView,"VIEW","FetchSize")>></FetchSize>
				<<>>			<MaxRecords><<DBGETPROP(tcView,"VIEW","MaxRecords")>></MaxRecords>
				<<>>			<Offline><<DBGETPROP(tcView,"VIEW","Offline")>></Offline>
				<<>>			<ParameterList><<DBGETPROP(tcView,"VIEW","ParameterList")>></ParameterList>
				<<>>			<Prepared><<DBGETPROP(tcView,"VIEW","Prepared")>></Prepared>
				<<>>			<RuleExpression><<DBGETPROP(tcView,"VIEW","RuleExpression")>></RuleExpression>
				<<>>			<RuleText><<DBGETPROP(tcView,"VIEW","RuleText")>></RuleText>
				<<>>			<SendUpdates><<DBGETPROP(tcView,"VIEW","SendUpdates")>></SendUpdates>
				<<>>			<ShareConnection><<DBGETPROP(tcView,"VIEW","ShareConnection")>></ShareConnection>
				<<>>			<SourceType><<DBGETPROP(tcView,"VIEW","SourceType")>></SourceType>
				<<>>			<UpdateType><<DBGETPROP(tcView,"VIEW","UpdateType")>></UpdateType>
				<<>>			<UseMemoSize><<DBGETPROP(tcView,"VIEW","UseMemoSize")>></UseMemoSize>
				<<>>			<WhereType><<DBGETPROP(tcView,"VIEW","WhereType")>></WhereType>
			ENDTEXT

			*-- ALGUNOS VALORES QUE EL DBGETPROP OFICIAL NO DEVUELVE
			*-- Path
			*-- OfflineRecordCount
			IF NOT EMPTY(THIS._Offline) AND EVALUATE(THIS._Offline)
				TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>			<Path><<THIS.DBGETPROP(tcView,"VIEW","Path")>></Path>
					<<>>			<RecordCount><<THIS.DBGETPROP(tcView,"VIEW","RecordCount")>></RecordCount>
				ENDTEXT
			ENDIF
			*--

			loFields	= THIS._Fields
			lcText		= lcText + loFields.toText( tcView )

			loIndexes	= THIS._Indexes
			lcText		= lcText + loIndexes.toText( tcView )

			loRelations	= CREATEOBJECT('CL_DBC_RELATIONS')
			lcText		= lcText + loRelations.toText( tcView )

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>		</VIEW>
			ENDTEXT


		CATCH TO loEx
			loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcView = " + RTRIM(TRANSFORM(tcView))

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE updateDBC
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_OutputFile				(v! IN    ) Nombre del archivo de salida
		* tnLastID					(@! IN    ) �ltimo n�mero de ID usado
		* tnParentID				(v! IN    ) ID del objeto Padre
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_OutputFile, tnLastID, tnParentID

		DODEFAULT( tc_OutputFile, @tnLastID, tnParentID)
		tnParentID	= THIS.__ObjectID
		THIS._Fields.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
		THIS._Indexes.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
		THIS._Relations.updateDBC( tc_OutputFile, @tnLastID, tnParentID )
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_VIEW OF 'FOXBIN2PRG.PRG'
			IF ._SourceType = 1
				lcBinData	= lcBinData + .getBinPropertyDataRecord( 6, .getDBCPropertyIDByName('Class', .T.) )
			ELSE
				lcBinData	= lcBinData + .getBinPropertyDataRecord( 7, .getDBCPropertyIDByName('Class', .T.) )
			ENDIF
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._UpdateType, .getDBCPropertyIDByName('UpdateType', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._WhereType, .getDBCPropertyIDByName('WhereType', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._FetchMemo, .getDBCPropertyIDByName('FetchMemo', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ShareConnection, .getDBCPropertyIDByName('ShareConnection', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._AllowSimultaneousFetch, .getDBCPropertyIDByName('AllowSimultaneousFetch', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._SendUpdates, .getDBCPropertyIDByName('SendUpdates', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Prepared, .getDBCPropertyIDByName('Prepared', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._CompareMemo, .getDBCPropertyIDByName('CompareMemo', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._FetchAsNeeded, .getDBCPropertyIDByName('FetchAsNeeded', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._FetchSize, .getDBCPropertyIDByName('FetchSize', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._MaxRecords, .getDBCPropertyIDByName('MaxRecords', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Tables, .getDBCPropertyIDByName('Tables', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._SQL, .getDBCPropertyIDByName('SQL', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._SourceType, .getDBCPropertyIDByName('SourceType', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._BatchUpdateCount, .getDBCPropertyIDByName('BatchUpdateCount', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleExpression, .getDBCPropertyIDByName('RuleExpression', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleText, .getDBCPropertyIDByName('RuleText', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ParameterList, .getDBCPropertyIDByName('ParameterList', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ConnectName, .getDBCPropertyIDByName('ConnectName', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._UseMemoSize, .getDBCPropertyIDByName('UseMemoSize', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Offline, .getDBCPropertyIDByName('Offline', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RecordCount, .getDBCPropertyIDByName('RecordCount', .T.) )	&& Undocumented
			lcBinData	= lcBinData + .getBinPropertyDataRecord( 0, .getDBCPropertyIDByName('undocumented_view_prop_85', .T.) )	&& Undocumented
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_FIELDS_VW AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_FIELDS_VW OF 'FOXBIN2PRG.PRG'
	#ENDIF


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loField AS CL_DBC_FIELD_VW OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELDS_I)) == C_FIELDS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELDS_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELD_I $ tcLine
						loField = CREATEOBJECT("CL_DBC_FIELD_VW")
						loField.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loField, loField._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcView					(v! IN    ) Nombre de la Vista
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcView

		TRY
			LOCAL X, lcText, lnField_Count, laFields(1), loEx AS EXCEPTION
			LOCAL loField AS CL_DBC_FIELD_VW OF 'FOXBIN2PRG.PRG'
			STORE 0 TO X, tnTable_Count, lnField_Count
			lcText	= ''

			_TALLY	= 0
			SELECT LOWER(TB.objectName) FROM TABLABIN TB ;
				INNER JOIN TABLABIN TB2 ON STR(TB.ParentID)+TB.ObjectType = STR(TB2.ObjectID)+PADR('Field',10) ;
				AND TB2.objectName = PADR(LOWER(tcView),128) ;
				INTO ARRAY laFields
			lnField_Count	= _TALLY

			IF lnField_Count > 0
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>			<FIELDS>
				ENDTEXT

				loField = CREATEOBJECT("CL_DBC_FIELD_VW")

				FOR X = 1 TO lnField_Count
					lcText	= lcText + loField.toText( tcView, laFields(X) )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>			</FIELDS>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF BETWEEN(X, 1, lnField_Count)
				loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "laFields(" + TRANSFORM(X) + ") = " + RTRIM(laFields(X))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TB"))
			USE IN (SELECT("TB2"))
		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_FIELD_VW AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_FIELD_VW OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_caption" display="_Caption"/>] ;
		+ [<memberdata name="_comment" display="_Comment"/>] ;
		+ [<memberdata name="_datatype" display="_DataType"/>] ;
		+ [<memberdata name="_defaultvalue" display="_DefaultValue"/>] ;
		+ [<memberdata name="_displayclass" display="_DisplayClass"/>] ;
		+ [<memberdata name="_displayclasslibrary" display="_DisplayClassLibrary"/>] ;
		+ [<memberdata name="_format" display="_Format"/>] ;
		+ [<memberdata name="_inputmask" display="_InputMask"/>] ;
		+ [<memberdata name="_keyfield" display="_KeyField"/>] ;
		+ [<memberdata name="_ruleexpression" display="_RuleExpression"/>] ;
		+ [<memberdata name="_ruletext" display="_RuleText"/>] ;
		+ [<memberdata name="_updatable" display="_Updatable"/>] ;
		+ [<memberdata name="_updatename" display="_UpdateName"/>] ;
		+ [</VFPData>]


	*-- Info
	_Name					= ''
	_Caption				= ''
	_Comment				= ''
	_DataType				= ''
	_DefaultValue			= ''
	_DisplayClass			= ''
	_DisplayClassLibrary	= ''
	_Format					= ''
	_InputMask				= ''
	_KeyField				= .F.
	_RuleExpression			= ''
	_RuleText				= ''
	_Updatable				= .F.
	_UpdateName				= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELD_I)) == C_FIELD_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELD_F $ tcLine	&& Fin
						EXIT

					CASE '<Comment>' $ tcLine
						THIS.analizarBloque_Comment( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Propiedad de FIELD
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF


		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcView					(v! IN    ) Nombre de la Vista
		* tcField					(v! IN    ) Nombre del campo
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcView, tcField

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>				<FIELD>
				<<>>					<Name><<RTRIM(tcField)>></Name>
				<<>>					<Caption><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","Caption")>></Caption>
				<<>>					<Comment><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","Comment")>></Comment>
				<<>>					<DataType><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","DataType")>></DataType>
				<<>>					<DefaultValue><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","DefaultValue")>></DefaultValue>
				<<>>					<DisplayClass><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","DefaultValue")>></DisplayClass>
				<<>>					<DisplayClassLibrary><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","DefaultValue")>></DisplayClassLibrary>
				<<>>					<Format><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","Format")>></Format>
				<<>>					<InputMask><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","InputMask")>></InputMask>
				<<>>					<KeyField><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","KeyField")>></KeyField>
				<<>>					<RuleExpression><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","RuleExpression")>></RuleExpression>
				<<>>					<RuleText><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","RuleText")>></RuleText>
				<<>>					<Updatable><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","Updatable")>></Updatable>
				<<>>					<UpdateName><<DBGETPROP( RTRIM(tcView) + '.' + RTRIM(tcField),"FIELD","UpdateName")>></UpdateName>
				<<>>				</FIELD>
			ENDTEXT


		CATCH TO loEx
			loEx.USERVALUE	= loEx.USERVALUE + CR_LF + "tcField = " + RTRIM(TRANSFORM(tcField))

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_FIELD_VW OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Comment, .getDBCPropertyIDByName('Comment', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DataType, .getDBCPropertyIDByName('DataType', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._KeyField, .getDBCPropertyIDByName('KeyField', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Updatable, .getDBCPropertyIDByName('UpdatableField', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._UpdateName, .getDBCPropertyIDByName('UpdateName', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DefaultValue, .getDBCPropertyIDByName('DefaultValue', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DisplayClass, .getDBCPropertyIDByName('DisplayClass', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._DisplayClassLibrary, .getDBCPropertyIDByName('DisplayClassLibrary', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Caption, .getDBCPropertyIDByName('Caption', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._Format, .getDBCPropertyIDByName('Format', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._InputMask, .getDBCPropertyIDByName('InputMask', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleExpression, .getDBCPropertyIDByName('RuleExpression', .T.) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._RuleText, .getDBCPropertyIDByName('RuleText', .T.) )
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_RELATIONS AS CL_DBC_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_RELATIONS OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loRelation AS CL_DBC_RELATION OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_RELATIONS_I)) == C_RELATIONS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_RELATIONS_F $ tcLine	&& Fin
						EXIT

					CASE C_RELATION_I $ tcLine
						loRelation = CREATEOBJECT("CL_DBC_RELATION")
						loRelation.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loRelation, loRelation._ChildTable + loRelation._ParentTable )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcTable					(v! IN    ) Tabla de la que obtener las relaciones
		* taRelations				(@?    OUT) Array de relaciones
		* tnRelation_Count			(@?    OUT) Cantidad de relaciones
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcTable, taRelations, tnRelation_Count

		EXTERNAL ARRAY taRelations

		TRY
			LOCAL I, X, lcText, loEx AS EXCEPTION
			LOCAL loRelation AS CL_DBC_RELATION OF 'FOXBIN2PRG.PRG'
			lcText	= ''
			X		= 0

			DIMENSION taRelations(1,5)
			tnRelation_Count	= ADBOBJECTS( taRelations,"RELATION" )

			IF tnRelation_Count > 0
				ASORT( taRelations, 2, -1, 0, 1 )
				ASORT( taRelations, 1, -1, 0, 1 )

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>			<RELATIONS>
				ENDTEXT

				loRelation	= CREATEOBJECT('CL_DBC_RELATION')

				FOR I = 1 TO tnRelation_Count
					IF taRelations(I,1) == UPPER( RTRIM( tcTable ) )
						lcText	= lcText + loRelation.toText( @taRelations, I )
					ENDIF
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>			</RELATIONS>
					<<>>
				ENDTEXT
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBC_RELATION AS CL_DBC_BASE
	#IF .F.
		LOCAL THIS AS CL_DBC_RELATION OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_childtable" display="_ChildTable"/>] ;
		+ [<memberdata name="_parenttable" display="_ParentTable"/>] ;
		+ [<memberdata name="_childindex" display="_ChildIndex"/>] ;
		+ [<memberdata name="_parentindex" display="_ParentIndex"/>] ;
		+ [<memberdata name="_refintegrity" display="_RefIntegrity"/>] ;
		+ [</VFPData>]


	*-- Info
	_ChildTable		= ''
	_ParentTable	= ''
	_ChildIndex		= ''
	_ParentIndex	= ''
	_RefIntegrity	= ''


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_RELATION_I)) == C_RELATION_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_RELATION_F $ tcLine	&& Fin
						EXIT

					OTHERWISE	&& Propiedad de RELATION
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.add_Property( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taRelations				(@! IN    ) Array de relaciones
		* I							(@! IN    ) N�mero de relaci�n evaluado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taRelations, I

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>				<RELATION>
				<<>>					<Name><<'Relation ' + TRANSFORM(I)>></Name>
				<<>>					<ChildTable><<ALLTRIM(taRelations(I,1))>></ChildTable>
				<<>>					<ParentTable><<ALLTRIM(taRelations(I,2))>></ParentTable>
				<<>>					<ChildIndex><<ALLTRIM(taRelations(I,3))>></ChildIndex>
				<<>>					<ParentIndex><<ALLTRIM(taRelations(I,4))>></ParentIndex>
				<<>>					<RefIntegrity><<ALLTRIM(taRelations(I,5))>></RefIntegrity>
				<<>>				</RELATION>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE getReferentialIntegrityInfo
		RETURN THIS._RefIntegrity
	ENDPROC


	PROCEDURE getBinMemoFromProperties
		LOCAL lcBinData
		lcBinData	= ''

		WITH THIS AS CL_DBC_RELATION OF 'FOXBIN2PRG.PRG'
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ChildIndex, .getDBCPropertyIDByName( 'ChildTag', .T. ) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ParentTable, .getDBCPropertyIDByName( 'ParentTable', .T. ) )
			lcBinData	= lcBinData + .getBinPropertyDataRecord( ._ParentIndex, .getDBCPropertyIDByName( 'ParentTag', .T. ) )
			*_ChildTable is used to link the name of the related table.
		ENDWITH && THIS

		RETURN lcBinData
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBF_TABLE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_DBF_TABLE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_codepage" display="_CodePage"/>] ;
		+ [<memberdata name="_database" display="_Database"/>] ;
		+ [<memberdata name="_filetype" display="_FileType"/>] ;
		+ [<memberdata name="_filetype_descrip" display="_FileType_Descrip"/>] ;
		+ [<memberdata name="_indexfile" display="_IndexFile"/>] ;
		+ [<memberdata name="_memofile" display="_MemoFile"/>] ;
		+ [<memberdata name="_lastupdate" display="_LastUpdate"/>] ;
		+ [<memberdata name="_fields" display="_Fields"/>] ;
		+ [<memberdata name="_indexes" display="_Indexes"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [<memberdata name="_fields" display="_Fields"/>] ;
		+ [<memberdata name="_indexes" display="_Indexes"/>] ;
		+ [</VFPData>]


	*-- Modulo
	_Version			= 0
	_SourceFile			= ''

	*-- Table Info
	_CodePage			= 0
	_Database			= ''
	_FileType			= ''
	_FileType_Descrip	= ''
	_IndexFile			= ''
	_MemoFile			= ''
	_LastUpdate			= {}

	*-- Fields and Indexes
	*_Fields				= NULL
	*_Indexes			= NULL


	PROCEDURE INIT
		DODEFAULT()
		*--
		THIS.ADDOBJECT("_Fields", "CL_DBF_FIELDS")
		THIS.ADDOBJECT("_Indexes", "CL_DBF_INDEXES")
	ENDPROC


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loFields AS CL_DBF_FIELDS OF 'FOXBIN2PRG.PRG'
			LOCAL loIndexes AS CL_DBF_INDEXES OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_TABLE_I)) == C_TABLE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_TABLE_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELDS_I $ tcLine
						loFields	= THIS._Fields
						loFields.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					CASE C_INDEXES_I $ tcLine
						loIndexes	= THIS._Indexes
						loIndexes.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )

					OTHERWISE	&& Otro valor
						*-- Estructura a reconocer:
						* 	<tagname>ID<tagname>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.ADDPROPERTY( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_FileTypeDesc			(v! IN    ) Tipo de archivo (en Hex)
		* tl_FileHasCDX				(v! IN    ) Indica si el archivo tiene CDX asociado
		* tl_FileHasMemo			(v! IN    ) Indica si el archivo tiene MEMO (FPT) asociado
		* tl_FileIsDBC				(v! IN    ) Indica si el archivo es un DBC
		* tc_DBC_Name				(v! IN    ) Nombre del DBC (si tiene)
		* tc_InputFile				(v! IN    ) Nombre del archivo de salida
		* tc_FileTypeDesc			(v! IN    ) Descripci�n del Tipo de archivo
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tn_HexFileType, tl_FileHasCDX, tl_FileHasMemo, tl_FileIsDBC, tc_DBC_Name, tc_InputFile, tc_FileTypeDesc

		TRY
			LOCAL lcText, loEx AS EXCEPTION
			LOCAL loFields AS CL_DBF_FIELDS OF 'FOXBIN2PRG.PRG'
			LOCAL loIndexes AS CL_DBF_INDEXES OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<C_TABLE_I>>
				<<>>	<MemoFile><<IIF( tl_FileHasMemo, FORCEEXT(tc_InputFile, 'FPT'), '' )>></MemoFile>
				<<>>	<CodePage><<CPDBF('TABLABIN')>></CodePage>
				<<>>	<LastUpdate><<LUPDATE('TABLABIN')>></LastUpdate>
				<<>>	<Database><<tc_DBC_Name>></Database>
				<<>>	<FileType><<TRANSFORM(tn_HexFileType, '@0')>></FileType>
				<<>>	<FileType_Descrip><<tc_FileTypeDesc>></FileType_Descrip>
			ENDTEXT

			*-- Fields
			loFields	= THIS._Fields
			lcText		= lcText + loFields.toText()

			*-- Indexes
			loIndexes	= THIS._Indexes
			lcText		= lcText + loIndexes.toText()

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TABLE_F>>
				<<>>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBF_FIELDS AS CL_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBF_FIELDS OF 'FOXBIN2PRG.PRG'
	#ENDIF


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loField AS CL_DBF_FIELD OF 'FOXBIN2PRG.PRG'
			LOCAL loIndex AS CL_DBF_INDEX OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELDS_I)) == C_FIELDS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELDS_F $ tcLine	&& Fin
						EXIT

					CASE C_FIELD_I $ tcLine
						loField = CREATEOBJECT("CL_DBF_FIELD")
						loField.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loField, loField._Name )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taFields					(@?    OUT) Array de informaci�n de campos
		* tnField_Count				(@?    OUT) Cantidad de campos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taFields, tnField_Count

		EXTERNAL ARRAY taFields

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			LOCAL loField AS CL_DBF_FIELD OF 'FOXBIN2PRG.PRG'
			lcText	= ''
			DIMENSION taFields(1,18)

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<>>	<<C_FIELDS_I>>
			ENDTEXT

			tnField_Count	= AFIELDS(taFields)
			loField			= CREATEOBJECT('CL_DBF_FIELD')

			FOR I = 1 TO tnField_Count
				lcText	= lcText + loField.toText( @taFields, I )
			ENDFOR

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>	<<C_FIELDS_F>>
				<<>>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBF_FIELD AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_DBF_FIELD OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_type" display="_Type"/>] ;
		+ [<memberdata name="_width" display="_Width"/>] ;
		+ [<memberdata name="_decimals" display="_Decimals"/>] ;
		+ [<memberdata name="_null" display="_Null"/>] ;
		+ [<memberdata name="_nocptran" display="_NoCPTran"/>] ;
		+ [<memberdata name="_field_valid_exp" display="_Field_Valid_Exp"/>] ;
		+ [<memberdata name="_field_valid_text" display="_Field_Valid_Text"/>] ;
		+ [<memberdata name="_field_default_value" display="_Field_Default_Value"/>] ;
		+ [<memberdata name="_table_valid_exp" display="_Table_Valid_Exp"/>] ;
		+ [<memberdata name="_table_valid_text" display="_Table_Valid_Text"/>] ;
		+ [<memberdata name="_longtablename" display="_LongTableName"/>] ;
		+ [<memberdata name="_ins_trig_exp" display="_Ins_Trig_Exp"/>] ;
		+ [<memberdata name="_upd_trig_exp" display="_Upd_Trig_Exp"/>] ;
		+ [<memberdata name="_del_trig_exp" display="_Del_Trig_Exp"/>] ;
		+ [<memberdata name="_tablecomment" display="_TableComment"/>] ;
		+ [<memberdata name="_autoinc_nextval" display="_AutoInc_NextVal"/>] ;
		+ [<memberdata name="_autoinc_step" display="_AutoInc_Step"/>] ;
		+ [</VFPData>]


	*-- Field Info
	_Name					= ''	&&  1
	_Type					= ''	&&  2
	_Width					= 0		&&  3
	_Decimals				= 0		&&  4
	_Null					= .F.	&&  5
	_NoCPTran				= .F.	&&  6
	_Field_Valid_Exp		= ''	&&  7	- DBC
	_Field_Valid_Text		= ''	&&  8	- DBC
	_Field_Default_Value	= ''	&&  9	- DBC
	_Table_Valid_Exp		= ''	&& 10	- DBC
	_Table_Valid_Text		= ''	&& 11	- DBC
	_LongTableName			= ''	&& 12	- DBC
	_Ins_Trig_Exp			= ''	&& 13	- DBC
	_Upd_Trig_Exp			= ''	&& 14	- DBC
	_Del_Trig_Exp			= ''	&& 15	- DBC
	_TableComment			= ''	&& 16	- DBC
	_AutoInc_NextVal		= 0		&& 17
	_AutoInc_Step			= 0		&& 18


	*******************************************************************************************************************
	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_FIELD_I)) == C_FIELD_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_FIELD_F $ tcLine	&& Fin
						EXIT

					OTHERWISE	&& Propiedad de FIELD
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.ADDPROPERTY( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taFields					(@! IN    ) Array de informaci�n de campos
		* I							(@! IN    ) Campo en evaluaci�n
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taFields, I

		EXTERNAL ARRAY taFields

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>		<<C_FIELD_I>>
				<<>>			<Name><<taFields(I,1)>></Name>
				<<>>			<Type><<taFields(I,2)>></Type>
				<<>>			<Width><<taFields(I,3)>></Width>
				<<>>			<Decimals><<taFields(I,4)>></Decimals>
				<<>>			<Null><<taFields(I,5)>></Null>
				<<>>			<NoCPTran><<taFields(I,6)>></NoCPTran>
				<<>>			<Field_Valid_Exp><<taFields(I,7)>></Field_Valid_Exp>
				<<>>			<Field_Valid_Text><<taFields(I,8)>></Field_Valid_Text>
				<<>>			<Field_Default_Value><<taFields(I,9)>></Field_Default_Value>
				<<>>			<Table_Valid_Exp><<taFields(I,10)>></Table_Valid_Exp>
				<<>>			<Table_Valid_Text><<taFields(I,11)>></Table_Valid_Text>
				<<>>			<LongTableName><<taFields(I,12)>></LongTableName>
				<<>>			<Ins_Trig_Exp><<taFields(I,13)>></Ins_Trig_Exp>
				<<>>			<Upd_Trig_Exp><<taFields(I,14)>></Upd_Trig_Exp>
				<<>>			<Del_Trig_Exp><<taFields(I,15)>></Del_Trig_Exp>
				<<>>			<TableComment><<taFields(I,16)>></TableComment>
				<<>>			<Autoinc_Nextval><<taFields(I,17)>></Autoinc_Nextval>
				<<>>			<Autoinc_Step><<taFields(I,18)>></Autoinc_Step>
				<<>>		<<C_FIELD_F>>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBF_INDEXES AS CL_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_DBF_INDEXES OF 'FOXBIN2PRG.PRG'
	#ENDIF


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL loIndex AS CL_DBF_INDEX OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_INDEXES_I)) == C_INDEXES_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_INDEXES_F $ tcLine	&& Fin
						EXIT

					CASE C_INDEX_I $ tcLine
						loIndex = CREATEOBJECT("CL_DBF_INDEX")
						loIndex.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines )
						THIS.ADD( loIndex, loIndex._TagName )

					OTHERWISE	&& Otro valor
						*-- No hay otros valores
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine)
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taTagInfo					(@?    OUT) Array de informaci�n de indices
		* tnTagInfo_Count			(@?    OUT) Cantidad de �ndices
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taTagInfo, tnTagInfo_Count

		EXTERNAL ARRAY taTagInfo

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			LOCAL loIndex AS CL_DBF_INDEX OF 'FOXBIN2PRG.PRG'
			lcText	= ''
			DIMENSION taTagInfo(1,6)

			IF TAGCOUNT() > 0
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<>>	<<C_CDX_I>><<CDX(1)>><<C_CDX_F>>
					<<>>
					<<>>	<<C_INDEXES_I>>
				ENDTEXT

				tnTagInfo_Count	= ATAGINFO( taTagInfo )
				loIndex			= CREATEOBJECT("CL_DBF_INDEX")

				FOR I = 1 TO tnTagInfo_Count
					lcText	= lcText + loIndex.toText( @taTagInfo, I )
				ENDFOR

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>	<<C_INDEXES_F>>
					<<>>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_DBF_INDEX AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_DBF_INDEX OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_tagname" display="_TagName"/>] ;
		+ [<memberdata name="_tagtype" display="_TagType"/>] ;
		+ [<memberdata name="_key" display="_Key"/>] ;
		+ [<memberdata name="_filter" display="_Filter"/>] ;
		+ [<memberdata name="_order" display="_Order"/>] ;
		+ [<memberdata name="_collate" display="_Collate"/>] ;
		+ [</VFPData>]


	*-- Index Info
	_TagName		= ''
	_TagType		= ''
	_Key			= ''
	_Filter			= ''
	_Order			= ''
	_Collate		= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines

		TRY
			LOCAL llBloqueEncontrado, lcPropName, lcValue, loEx AS EXCEPTION
			STORE '' TO lcPropName, lcValue

			IF LEFT(tcLine, LEN(C_INDEX_I)) == C_INDEX_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE C_INDEX_F $ tcLine	&& Fin
						EXIT

					OTHERWISE	&& Propiedad de INDEX
						*-- Estructura a reconocer:
						*	<name>NOMBRE</name>
						lcPropName	= STREXTRACT( tcLine, '<', '>', 1, 0 )
						lcValue		= STREXTRACT( tcLine, '<' + lcPropName + '>', '</' + lcPropName + '>', 1, 0 )
						THIS.ADDPROPERTY( '_' + lcPropName, lcValue )
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'I=' + TRANSFORM(I) + ', tcLine=' + TRANSFORM(tcLine) + ', PropName=[' + TRANSFORM(lcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* taTagInfo					(@? IN    ) Array de informaci�n de indices
		* I							(@? IN    ) Indice en evaluaci�n
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS taTagInfo, I

		EXTERNAL ARRAY taTagInfo

		TRY
			LOCAL I, lcText, loEx AS EXCEPTION
			lcText	= ''

			TEXT TO lcText TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>		<INDEX>
				<<>>			<TagName><<taTagInfo(I,1)>></TagName>
				<<>>			<TagType><<ICASE(LEFT(taTagInfo(I,2),3)='BIN','BINARY',PRIMARY(I),'PRIMARY',CANDIDATE(I),'CANDIDATE',UNIQUE(I),'UNIQUE','REGULAR'))>></TagType>
				<<>>			<Key><<taTagInfo(I,3)>></Key>
				<<>>			<Filter><<taTagInfo(I,4)>></Filter>
				<<>>			<Order><<IIF(DESCENDING(I), 'DESCENDING', 'ASCENDING')>></Order>
				<<>>			<Collate><<taTagInfo(I,6)>></Collate>
				<<>>		</INDEX>
			ENDTEXT


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_HEAD AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_internalname" display="_InternalName"/>] ;
		+ [<memberdata name="_libraryname" display="_LibraryName"/>] ;
		+ [<memberdata name="_projectname" display="_ProjectName"/>] ;
		+ [<memberdata name="_servercount" display="_ServerCount"/>] ;
		+ [<memberdata name="_servers" display="_Servers"/>] ;
		+ [<memberdata name="_servertype" display="_ServerType"/>] ;
		+ [<memberdata name="_typelib" display="_TypeLib"/>] ;
		+ [<memberdata name="_typelibdesc" display="_TypeLibDesc"/>] ;
		+ [<memberdata name="add_server" display="add_Server"/>] ;
		+ [<memberdata name="getdatafrompair_lendata_structure" display="getDataFromPair_LenData_Structure"/>] ;
		+ [<memberdata name="getformattedservertext" display="getFormattedServerText"/>] ;
		+ [<memberdata name="getrowserverinfo" display="getRowServerInfo"/>] ;
		+ [<memberdata name="getserverdataobject" display="getServerDataObject"/>] ;
		+ [<memberdata name="parseserverinfo" display="parseServerInfo"/>] ;
		+ [<memberdata name="setparsedheadinfoline" display="setParsedHeadInfoLine"/>] ;
		+ [<memberdata name="setparsedinfoline" display="setParsedInfoLine"/>] ;
		+ [</VFPData>]

	*-- Informaci�n interesante sobre Servidores OLE y corrupci�n de IDs: http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=880

	*-- Server Head info
	DIMENSION _Servers[1]
	_ServerCount		= 0
	_LibraryName		= ''
	_InternalName		= ''
	_ProjectName		= ''
	_TypeLibDesc		= ''
	_ServerType			= ''
	_TypeLib			= ''


	************************************************************************************************
	PROCEDURE setParsedHeadInfoLine
		LPARAMETERS tcHeadInfoLine
		THIS.setParsedInfoLine( THIS, tcHeadInfoLine )
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedInfoLine
		LPARAMETERS toObject, tcInfoLine
		LOCAL lcAsignacion, lcCurDir
		IF LEFT(tcInfoLine,1) == '.'
			lcAsignacion	= 'toObject' + tcInfoLine
		ELSE
			lcAsignacion	= 'toObject.' + tcInfoLine
		ENDIF
		&lcAsignacion.
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Server
		LPARAMETERS toServerData

		#IF .F.
			LOCAL toServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._ServerCount	= THIS._ServerCount + 1
		DIMENSION THIS._Servers( THIS._ServerCount )
		THIS._Servers( THIS._ServerCount )	= toServerData
	ENDPROC


	************************************************************************************************
	PROCEDURE getDataFromPair_LenData_Structure
		LPARAMETERS tcData, tnPos, tnLen
		LOCAL lcData, lnLen
		tnPos	= tnPos + 4 + tnLen
		tnLen	= INT( VAL( SUBSTR( tcData, tnPos, 4 ) ) )
		lcData	= SUBSTR( tcData, tnPos + 4, tnLen )
		RETURN lcData
	ENDPROC


	PROCEDURE getServerDataObject
		RETURN CREATEOBJECT('CL_PROJ_SRV_DATA')
	ENDPROC


	************************************************************************************************
	PROCEDURE parseServerInfo
		LPARAMETERS tcServerInfo

		IF NOT EMPTY(tcServerInfo)
			TRY
				LOCAL loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

				WITH THIS
					lcStr			= ''
					lnPos			= 1
					lnLen			= 4

					lnServerCount	= INT( VAL( .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen ) ) )
					._LibraryName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._InternalName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._ProjectName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._TypeLibDesc	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._ServerType	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._TypeLib		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )

					*-- Informaci�n de los servidores
					FOR I = 1 TO lnServerCount
						loServerData	= NULL
						loServerData	= .getServerDataObject()

						loServerData._HelpContextID	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ServerName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Description	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._HelpFile		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ServerClass	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ClassLibrary	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Instancing	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._CLSID			= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Interface		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )

						THIS.add_Server( loServerData )
					ENDFOR

				ENDWITH && THIS
				loServerData	= NULL

			CATCH TO loEx
				IF THIS.l_Debug AND _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF

				THROW

			ENDTRY

		ENDIF
	ENDPROC


	************************************************************************************************
	PROCEDURE getRowServerInfo
		TRY
			LOCAL lcStr, lnLenH, lnLen, lnPos ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			lcStr				= ''

			IF THIS._ServerCount > 0
				WITH THIS
					lnPos		= 1
					lnLen		= 4
					lnLenH		= 8 + LEN(._LibraryName) + 4 + LEN(._InternalName) + 4 + LEN(._ProjectName) + 4 + LEN(._TypeLibDesc) - 1

					*-- Header
					lcStr		= lcStr + PADL( 4, 4, ' ' ) + PADL( lnLenH, 4, ' ' )
					lcStr		= lcStr + PADL( 4, 4, ' ' ) + PADL( ._ServerCount, 4, ' ' )
					lcStr		= lcStr + PADL( LEN(._LibraryName), 4, ' ' ) + ._LibraryName
					lcStr		= lcStr + PADL( LEN(._InternalName), 4, ' ' ) + ._InternalName
					lcStr		= lcStr + PADL( LEN(._ProjectName), 4, ' ' ) + ._ProjectName
					lcStr		= lcStr + PADL( LEN(._TypeLibDesc), 4, ' ' ) + ._TypeLibDesc
					lcStr		= lcStr + PADL( LEN(._ServerType), 4, ' ' ) + ._ServerType
					lcStr		= lcStr + PADL( LEN(._TypeLib), 4, ' ' ) + ._TypeLib

					FOR I = 1 TO ._ServerCount
						loServerData	= ._Servers(I)
						lcStr		= lcStr + loServerData.getRowServerInfo()
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcStr
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedServerText
		TRY
			LOCAL lcText ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_SRV_HEAD_I>>
				_LibraryName = '<<THIS._LibraryName>>'
				_InternalName = '<<THIS._InternalName>>'
				_ProjectName = '<<THIS._ProjectName>>'
				_TypeLibDesc = '<<THIS._TypeLibDesc>>'
				_ServerType = '<<THIS._ServerType>>'
				_TypeLib = '<<THIS._TypeLib>>'
				<<C_SRV_HEAD_F>>
			ENDTEXT

			*-- Recorro los servidores
			FOR I = 1 TO THIS._ServerCount
				loServerData	= THIS._Servers(I)
				lcText			= lcText + loServerData.getFormattedServerText()
				loServerData	= NULL
			ENDFOR

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_DATA AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_classlibrary" display="_ClassLibrary"/>] ;
		+ [<memberdata name="_clsid" display="_CLSID"/>] ;
		+ [<memberdata name="_description" display="_Description"/>] ;
		+ [<memberdata name="_helpcontextid" display="_HelpContextID"/>] ;
		+ [<memberdata name="_helpfile" display="_HelpFile"/>] ;
		+ [<memberdata name="_interface" display="_Interface"/>] ;
		+ [<memberdata name="_instancing" display="_Instancing"/>] ;
		+ [<memberdata name="_serverclass" display="_ServerClass"/>] ;
		+ [<memberdata name="_servername" display="_ServerName"/>] ;
		+ [<memberdata name="getformattedservertext" display="getFormattedServerText"/>] ;
		+ [<memberdata name="getrowserverinfo" display="getRowServerInfo"/>] ;
		+ [</VFPData>]

	_HelpContextID	= 0
	_ServerName		= ''
	_Description	= ''
	_HelpFile		= ''
	_ServerClass	= ''
	_ClassLibrary	= ''
	_Instancing		= 0
	_CLSID			= ''
	_Interface		= ''


	************************************************************************************************
	PROCEDURE getRowServerInfo
		TRY
			LOCAL lcStr, lnLen, lnPos

			lcStr				= ''

			IF NOT EMPTY(THIS._ServerName)
				WITH THIS
					lnPos				= 1
					lnLen				= 4

					*-- Data
					lcStr	= lcStr + PADL( LEN(._HelpContextID), 4, ' ' ) + ._HelpContextID
					lcStr	= lcStr + PADL( LEN(._ServerName), 4, ' ' ) + ._ServerName
					lcStr	= lcStr + PADL( LEN(._Description), 4, ' ' ) + ._Description
					lcStr	= lcStr + PADL( LEN(._HelpFile), 4, ' ' ) + ._HelpFile
					lcStr	= lcStr + PADL( LEN(._ServerClass), 4, ' ' ) + ._ServerClass
					lcStr	= lcStr + PADL( LEN(._ClassLibrary), 4, ' ' ) + ._ClassLibrary
					lcStr	= lcStr + PADL( LEN(._Instancing), 4, ' ' ) + ._Instancing
					lcStr	= lcStr + PADL( LEN(._CLSID), 4, ' ' ) + ._CLSID
					lcStr	= lcStr + PADL( LEN(._Interface), 4, ' ' ) + ._Interface
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcStr
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedServerText
		TRY
			LOCAL lcText
			lcText	= ''

			WITH THIS
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_SRV_DATA_I>>
					_HelpContextID = '<<._HelpContextID>>'
					_ServerName = '<<._ServerName>>'
					_Description = '<<._Description>>'
					_HelpFile = '<<._HelpFile>>'
					_ServerClass = '<<._ServerClass>>'
					_ClassLibrary = '<<._ClassLibrary>>'
					_Instancing = '<<._Instancing>>'
					_CLSID = '<<._CLSID>>'
					_Interface = '<<._Interface>>'
					<<C_SRV_DATA_F>>
				ENDTEXT
			ENDWITH

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC

ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_FILE AS CL_CUS_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_comments" display="_Comments"/>] ;
		+ [<memberdata name="_cpid" display="_CPID"/>] ;
		+ [<memberdata name="_exclude" display="_Exclude"/>] ;
		+ [<memberdata name="_id" display="_ID"/>] ;
		+ [<memberdata name="_name" display="_Name"/>] ;
		+ [<memberdata name="_objrev" display="_ObjRev"/>] ;
		+ [<memberdata name="_timestamp" display="_Timestamp"/>] ;
		+ [<memberdata name="_type" display="_Type"/>] ;
		+ [</VFPData>]

	_Name				= ''
	_Type				= ''
	_Exclude			= .F.
	_Comments			= ''
	_CPID				= 0
	_ID					= 0
	_ObjRev				= 0
	_TimeStamp			= 0

ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_MENU_COL_BASE AS CL_COL_BASE
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="oreg" display="oReg"/>] ;
		+ [<memberdata name="analizarsiexpresionescomandooprocedimiento" display="AnalizarSiExpresionEsComandoOProcedimiento"/>] ;
		+ [<memberdata name="get_datafromtablabin" display="get_DataFromTablabin"/>] ;
		+ [<memberdata name="updatemenu" display="updateMENU"/>] ;
		+ [</VFPData>]


	#IF .F.
		LOCAL THIS AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
	#ENDIF

	oReg			= NULL


	PROCEDURE get_DataFromTablabin
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toReg						(v! IN    ) Objeto de datos del registro
		* toCol_LastLevelName		(v! IN    ) Objeto collection con la pila de niveles analizados
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toReg, toCol_LastLevelName AS COLLECTION

		TRY
			LOCAL I, lcLevelName, lnLastKey, llRetorno, llHayDatos, loReg ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG' ;
				, loOption AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'

			lnLastKey	= 0
			THIS.oReg	= toReg
			lcLevelName	= toReg.LevelName
			lnLastKey	= IIF( toCol_LastLevelName.COUNT=0, 0, toCol_LastLevelName.GETKEY(toReg.LevelName ) )

			IF lnLastKey = 0
				toCol_LastLevelName.ADD( toReg.LevelName, toReg.LevelName )
			ENDIF

			DO WHILE NOT EOF()
				loReg		= NULL
				SKIP 1

				IF EOF()
					EXIT
				ENDIF

				SCATTER MEMO NAME loReg

				lnLastKey	= toCol_LastLevelName.GETKEY(loReg.LevelName)

				DO CASE
				CASE EOF()
					llRetorno	= .T.
					EXIT

				CASE lnLastKey > 0 AND lnLastKey < toCol_LastLevelName.COUNT
					*-- El nombre del analizado actual ya existe y no es el �ltimo,
					*-- as� que corresponde a un nivel superior.
					SKIP -1
					llRetorno	= .F.
					EXIT

				CASE loReg.ObjType = 3 AND toReg.ObjType = 3 OR loReg.ObjType = 2 AND toReg.ObjType = 2
					*-- Un objeto Option no puede anidar a otro Option,
					*-- y un objeto Bar/Popup no puede anidar a otro Bar/Popup
					SKIP -1
					llRetorno	= .F.
					EXIT

				CASE loReg.ObjType = 2	&& Bar or Popup
					loBarPop	= CREATEOBJECT('CL_MENU_BARPOP')
					llHayDatos	= loBarPop.get_DataFromTablabin( loReg, toCol_LastLevelName )
					llRetorno	= .T.
					llRetorno	= llHayDatos
					THIS.ADD( loBarPop )
					loBarPop	= NULL
					IF NOT llHayDatos AND toReg.ObjType = 3
						EXIT
					ENDIF

				CASE loReg.ObjType = 3	&& Option
					loOption	= CREATEOBJECT('CL_MENU_OPTION')
					llHayDatos	= loOption.get_DataFromTablabin( loReg, toCol_LastLevelName )
					llRetorno	= llHayDatos
					THIS.ADD( loOption )
					loOption	= NULL
					IF NOT llHayDatos AND toReg.ObjType = 3
						EXIT
					ENDIF

				OTHERWISE
					llRetorno	= .T.
					EXIT

				ENDCASE
			ENDDO

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loBarPop, loOption
			IF toReg.ObjType = 2
				lnLastKey	= toCol_LastLevelName.GETKEY(toReg.LevelName)
				IF lnLastKey > 0
					toCol_LastLevelName.REMOVE(lnLastKey)
				ENDIF
			ENDIF
		ENDTRY

		RETURN llRetorno
	ENDPROC


	PROCEDURE updateMENU
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toConversor
	ENDPROC


	PROCEDURE AnalizarSiExpresionEsComandoOProcedimiento
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcExpr					(v! IN    ) Expresi�n a analizar (puede ser una l�nea o un Procedure)
		* tcProcName				(@!    OUT) Nombre del Procedimiento, si se encuentra uno
		* tcProcCode				(@!    OUT) C�digo del Procedimiento, si se encuentra uno
		* tcSourceCode				(@? IN    ) Si se indica, se buscar� el nombre de Procedure para obtener su c�digo
		* tnIndentation				(v? IN    ) En caso de devolver c�digo, indica si se debe indentar o quitar indentaci�n
		* tlAddProcEndproc			(v? IN    ) En caso de devolver c�digo, indica si se debe encerrar con PROCEDURE/ENDPROC
		*---------------------------------------------------------------------------------------------------
		* DETALLE: Los menus guardan en los primeros registros los Comandos o Procedimientos en el campo PROCEDURE,
		*		y luego al generar el c�digo lo muestran como Comando si es una sola l�nea, y si no como Procedure.
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcExpr, tcProcName, tcProcCode, tcSourceCode, tnIndentation, tlAddProcEndproc

		LOCAL laProcLines(1), lnLine_Count, I
		tcProcName		= ''
		tcProcCode		= ''
		tnIndentation	= EVL(tnIndentation,0)
		lnLine_Count	= ALINES( laProcLines, tcExpr )

		IF lnLine_Count > 1
			*-- ES UN PROCEDIMIENTO
			tcProcCode	= tcExpr

			FOR I = 1 TO lnLine_Count
				*-- Si existe el snippet #NAME, lo usa
				IF EMPTY(tcProcName) AND UPPER( LEFT( ALLTRIM(laProcLines(I)), 6 ) ) == '#NAME '
					tcProcName	= ALLTRIM( SUBSTR( ALLTRIM(laProcLines(I)), 7 ) )
					EXIT
				ENDIF
			ENDFOR
		ELSE
			*-- ES UN COMANDO, PERO PODR�A REFERENCIAR A UN PROCEDURE DEL MENU, SE VERIFICA.
			IF NOT EMPTY(tcSourceCode)
				IF LEFT( tcExpr, 3 ) == 'DO '
					*-- Parece un Procedimiento, vamos a confirmarlo.
					tcProcName	= ALLTRIM( STREXTRACT( tcExpr, 'DO ', '&'+'&', 1, 2 ) )
					tcProcCode	= STREXTRACT( tcSourceCode, 'PROCEDURE ' + tcProcName + CR_LF, CR_LF + 'ENDPROC &'+'& ' + tcProcName )
					IF EMPTY(tcProcCode)
						*-- Era un Command al final, o un Procedure externo,
						*-- que para el caso es lo mismo porque no es del Menu.
						tcProcName	= ''
					ENDIF
				ENDIF
			ENDIF
		ENDIF

		*-- Si se indic� indentaci�n, se reprocesa el c�digo del procedimiento
		IF NOT EMPTY(tcProcCode) AND (tnIndentation <> 0 OR tlAddProcEndproc)
			lnLine_Count	= ALINES( laProcLines, tcProcCode )
			tcProcCode		= ''

			IF tlAddProcEndproc
				*tcProcCode	= '*' + REPLICATE('-',34) + CR_LF + 'PROCEDURE <<ProcName>>' + CR_LF
				tcProcCode	= 'PROCEDURE <<ProcName>>' + CR_LF
			ENDIF

			DO CASE
			CASE tnIndentation = 0
				FOR I = 1 TO lnLine_Count
					*-- No Indentar
					tcProcCode	= tcProcCode + laProcLines(I) + CR_LF
				ENDFOR

			CASE tnIndentation > 0
				FOR I = 1 TO lnLine_Count
					*-- Indentar
					tcProcCode	= tcProcCode + C_TAB + laProcLines(I) + CR_LF
				ENDFOR

			OTHERWISE
				FOR I = 1 TO lnLine_Count
					*-- Quitar indentaci�n
					IF INLIST( LEFT(laProcLines(I),1), SPACE(1), C_TAB )
						tcProcCode	= tcProcCode + SUBSTR( laProcLines(I), 2 ) + CR_LF
					ELSE
						tcProcCode	= tcProcCode + laProcLines(I) + CR_LF
					ENDIF
				ENDFOR
			ENDCASE

			IF tlAddProcEndproc
				tcProcCode	= tcProcCode + 'ENDPROC &' + '& <<ProcName>>' + CR_LF
			ENDIF
		ENDIF

	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_MENU AS CL_MENU_COL_BASE
	#IF .F.
		LOCAL THIS AS CL_MENU OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_cleanupcode" display="analizarBloque_CleanupCode"/>] ;
		+ [<memberdata name="analizarbloque_menucode" display="analizarBloque_MenuCode"/>] ;
		+ [<memberdata name="analizarbloque_procedure" display="analizarBloque_PROCEDURE"/>] ;
		+ [<memberdata name="analizarbloque_setupcode" display="analizarBloque_SetupCode"/>] ;
		+ [<memberdata name="updatemenu_recursivo" display="UpdateMenu_Recursivo"/>] ;
		+ [<memberdata name="_sourcefile" display="_SourceFile"/>] ;
		+ [<memberdata name="_version" display="_Version"/>] ;
		+ [</VFPData>]


	*-- Modulo
	_Version			= 0
	_SourceFile			= ''


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loOptions AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'
			LOCAL loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, loReg, lcComment, lcExpr, lcProcName, lcProcCode, loEx AS EXCEPTION ;
				, llBloque_SetupCode_Analizado, llBloque_CleanupCode_Analizado, llBloque_MenuCode_Analizado ;
				, llBloque_MenuType_Analizado, llBloque_Procedure_Analizado, llBloque_MenuLocation_Analizado
			STORE '' TO lcComment

			llBloqueEncontrado	= .T.

			*-- CABECERA DEL MENU
			THIS.oReg	= toConversor.emptyRecord()
			loReg		= THIS.oReg

			FOR I = I + 0 TO tnCodeLines
				THIS.set_Line( @tcLine, @taCodeLines, I )

				DO CASE
				CASE EMPTY( tcLine )
					LOOP

				CASE toConversor.lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
					LOOP	&& Saltear comentarios

				CASE NOT llBloque_MenuType_Analizado AND LEFT( tcLine, LEN(C_MENUTYPE_I) ) == C_MENUTYPE_I
					toConversor.n_MenuType		= INT( VAL( STREXTRACT( tcLine, C_MENUTYPE_I, C_MENUTYPE_F ) ) )
					loReg.ObjType		= toConversor.n_MenuType
					llBloque_MenuType_Analizado	= .T.

				CASE NOT llBloque_MenuLocation_Analizado AND LEFT( tcLine, LEN(C_MENULOCATION_I) ) == C_MENULOCATION_I
					toConversor.c_MenuLocation	= STREXTRACT( tcLine, C_MENULOCATION_I, C_MENULOCATION_F )
					DO CASE
					CASE toConversor.c_MenuLocation == 'REPLACE'
						loReg.Location		= 0
					CASE toConversor.c_MenuLocation == 'APPEND'
						loReg.Location		= 1
					OTHERWISE
						IF LEFT(toConversor.c_MenuLocation,7) == 'BEFORE'
							loReg.Location		= 2
						ELSE
							loReg.Location		= 3
						ENDIF
						loReg.NAME	= GETWORDNUM(toConversor.c_MenuLocation,2)
					ENDCASE
					llBloque_MenuLocation_Analizado	= .T.

				CASE NOT llBloque_SetupCode_Analizado AND THIS.analizarBloque_SetupCode( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					llBloque_SetupCode_Analizado	= .T.

				CASE NOT llBloque_MenuCode_Analizado AND THIS.analizarBloque_MenuCode( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					llBloque_MenuCode_Analizado		= .T.

				CASE NOT llBloque_CleanupCode_Analizado AND THIS.analizarBloque_CleanupCode( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					llBloque_CleanupCode_Analizado	= .T.

				CASE NOT llBloque_Procedure_Analizado AND THIS.analizarBloque_PROCEDURE( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					llBloque_Procedure_Analizado	= .T.

				OTHERWISE	&& Otro valor
					*EXIT
				ENDCASE
			ENDFOR

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_SetupCode
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcText, lcComment, loEx AS EXCEPTION
			STORE '' TO lcText, lcComment

			IF LEFT(tcLine, LEN(C_SETUPCODE_I)) == C_SETUPCODE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE C_SETUPCODE_F $ tcLine	&& Fin
						I = I + 1
						EXIT

					OTHERWISE	&& L�neas de procedure
						lcText	= lcText + CR_LF + taCodeLines(I)
					ENDCASE
				ENDFOR

				I = I - 1
				THIS.oReg.SETUP = SUBSTR( lcText, 3 )	&& Quito el primer CR_LF
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_CleanupCode
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcText, lcComment, loEx AS EXCEPTION
			STORE '' TO lcText, lcComment

			IF LEFT(tcLine, LEN(C_CLEANUPCODE_I)) == C_CLEANUPCODE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE C_CLEANUPCODE_F $ tcLine	&& Fin
						I = I + 1
						EXIT

					OTHERWISE	&& L�neas de procedure
						lcText	= lcText + CR_LF + taCodeLines(I)
					ENDCASE
				ENDFOR

				I = I - 1
				THIS.oReg.Cleanup = SUBSTR( lcText, 3 )	&& Quito el primer CR_LF
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_MenuCode
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loOptions AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'
			LOCAL loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcExpr, lcProcName, lcProcCode, lcComment, loReg, loEx AS EXCEPTION ;
				, llBloque_SetupCode_Analizado
			STORE '' TO lcExpr, lcProcName, lcProcCode, lcComment
			loReg		= THIS.oReg

			IF LEFT(tcLine, LEN(C_MENUCODE_I)) == C_MENUCODE_I
				llBloqueEncontrado	= .T.


				FOR I = I + 0 TO tnCodeLines
					STORE '' TO lcExpr, lcProcName, lcProcCode
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE toConversor.lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
						LOOP	&& Saltear comentarios

					CASE LEFT( tcLine, LEN(C_MENUCODE_F) ) == C_MENUCODE_F
						EXIT

					CASE LEFT( tcLine, LEN(C_MENUCODE_I) ) == C_MENUCODE_I

					CASE LEFT( tcLine, 12 ) == 'DEFINE MENU '
						loReg.OBJCODE		= 22
						loReg.PROCTYPE		= 1
						loReg.MARK			= CHR(4)
						loReg.SETUPTYPE		= 1
						loReg.CLEANTYPE		= 1
						loReg.ITEMNUM		= STR(0,3)
						lcMenuType			= ALLTRIM( GETWORDNUM( tcLine, 3 ) )
						*loReg.ObjType		= IIF( UPPER(lcMenuType) = '_MSYSMENU', 1, 5 )

						lcExpr			= ALLTRIM( STREXTRACT( C_FB2PRG_CODE, 'ON SELECTION MENU _MSYSMENU ', CR_LF ) )

						IF NOT EMPTY(lcExpr)
							THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1, .F. )

							IF EMPTY(lcProcCode)
								*-- Comando
								loReg.PROCEDURE	= lcExpr
							ELSE
								*-- Procedure
								lcProcCode	= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )
								loReg.PROCEDURE	= lcProcCode
							ENDIF
						ENDIF

						loBarPop	= CREATEOBJECT('CL_MENU_BARPOP')
						loBarPop.c_ParentName	= ''
						loBarPop.n_ParentCode	= THIS.oReg.OBJCODE
						loBarPop.n_ParentType	= THIS.oReg.ObjType
						loBarPop.analizarBloque( @tcLine, @taCodeLines, @I, @tnCodeLines, toConversor )
						THIS.ADD( loBarPop )
						EXIT

					CASE LEFT( tcLine, 13 ) == 'DEFINE POPUP '
						loReg.OBJCODE		= 22
						loReg.PROCTYPE		= 1
						loReg.MARK			= CHR(4)
						loReg.SETUPTYPE		= 1
						loReg.CLEANTYPE		= 1
						loReg.ITEMNUM		= STR(0,3)
						loReg.SCHEME		= 0
						lcExpr				= ALLTRIM( STREXTRACT( C_FB2PRG_CODE, 'ON SELECTION POPUP ALL ', CR_LF ) )
						THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1, .F. )

						IF EMPTY(lcProcCode)
							*-- Comando
							loReg.PROCEDURE	= lcExpr
						ELSE
							*-- Procedure
							lcProcCode	= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )
							loReg.PROCEDURE	= lcProcCode
						ENDIF

						loBarPop	= CREATEOBJECT('CL_MENU_BARPOP')
						loBarPop.c_ParentName	= ''
						loBarPop.n_ParentCode	= THIS.oReg.OBJCODE
						loBarPop.n_ParentType	= THIS.oReg.ObjType
						loBarPop.analizarBloque( @tcLine, @taCodeLines, @I, @tnCodeLines, toConversor )
						THIS.ADD( loBarPop )

						*-- Creo option
						loOption		= CREATEOBJECT("CL_MENU_OPTION")
						loOption.oReg	= toConversor.emptyRecord()
						WITH loOption.oReg
							.ObjType	= 3
							.OBJCODE	= 77
							.MARK		= CHR(0)
							.PROMPT		= '\<Shortcut'
							.LevelName	= '_MSYSMENU'
							loBarPop.ADD( loOption )
							loBarPop.oReg.NUMITEMS	= loBarPop.COUNT
							.ITEMNUM	= STR(loBarPop.COUNT,3)
							.SCHEME	= 0
							loBarPop		= NULL
						ENDWITH

						*-- Creo BarPop
						loBarPop		= CREATEOBJECT('CL_MENU_BARPOP')
						loBarPop.c_ParentName	= ''
						loBarPop.n_ParentCode	= loOption.oReg.OBJCODE
						loBarPop.n_ParentType	= loOption.oReg.ObjType
						loBarPop.analizarBloque( @tcLine, @taCodeLines, @I, @tnCodeLines, toConversor )
						loOption.ADD( loBarPop )
						loBarPop		= NULL
						loOption		= NULL
						EXIT

					OTHERWISE	&& Otro valor
						I	= I - 1
						EXIT
					ENDCASE
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			loBarPop	= NULL
			loReg		= NULL

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_PROCEDURE
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcText, lcComment, lcProcName, loEx AS EXCEPTION
			STORE '' TO lcText, lcComment

			IF LEFT(tcLine, LEN(C_PROC_CODE_I)) == C_PROC_CODE_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE C_PROC_CODE_F $ tcLine	&& Fin
						I = I + 1
						EXIT

					OTHERWISE	&& L�neas de procedure
						*-- Las saltea
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		*---------------------------------------------------------------------------------------------------

		TRY
			LOCAL lcText, loReg, loHeader, lnNivel, lcEndProcedures, lcExpr, lcProcName, lcProcCode, lcLocation ;
				, loEx AS EXCEPTION ;
				, loCol_LastLevelName AS COLLECTION ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG' ;
				, loOption AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'

			STORE '' TO lcText, lcEndProcedures
			loReg		= THIS.oReg
			loHeader	= loReg
			loBarPop	= THIS.ITEM(1).oReg
			lnNivel		= 0

			DO CASE
			CASE loReg.Location = 0
				lcLocation	= 'REPLACE'
			CASE loReg.Location = 1
				lcLocation	= 'APPEND'
			CASE loReg.Location = 2
				lcLocation	= 'BEFORE ' + loReg.NAME
			CASE loReg.Location = 3
				lcLocation	= 'AFTER ' + loReg.NAME
			ENDCASE

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_MENUTYPE_I>><<loReg.ObjType>><<C_MENUTYPE_F>>
				<<C_MENULOCATION_I>><<lcLocation>><<C_MENULOCATION_F>>
			ENDTEXT

			IF NOT EMPTY(loReg.SETUP)
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<C_SETUPCODE_I>>
					<<loReg.Setup>>
					<<C_SETUPCODE_F>>
				ENDTEXT
			ENDIF

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<>>
				<<C_MENUCODE_I>>
			ENDTEXT

			DO CASE
			CASE loHeader.ObjType = 1	&& Menu Bar (Sistema)
				*lcText	= lcText + CR_LF + 'DEFINE MENU _MSYSMENU BAR'
				lcText	= lcText + CR_LF + 'DEFINE MENU ' + loBarPop.NAME + ' BAR'

			CASE loHeader.ObjType = 5	&& Menu Bar (On top)
				*lcText	= lcText + CR_LF + 'DEFINE MENU _ONTOP BAR'
				lcText	= lcText + CR_LF + 'DEFINE MENU ' + loBarPop.NAME + ' BAR'

			CASE loHeader.ObjType = 4	&& Shortcut
				lcText	= lcText + CR_LF + 'DEFINE POPUP ' + THIS.ITEM(1).ITEM(1).ITEM(1).oReg.NAME + ' SHORTCUT RELATIVE FROM MROW(),MCOL()'

			ENDCASE


			*-- Bars and Popups
			IF THIS.COUNT > 0
				FOR EACH loBarPop IN THIS FOXOBJECT
					lcText		= lcText + loBarPop.toText(loReg, lnNivel+0, @lcEndProcedures, loHeader)
				ENDFOR
			ENDIF

			loBarPop	= THIS.ITEM(1).oReg

			DO CASE
			CASE loHeader.ObjType = 1 OR loHeader.ObjType = 5
				*-- Propecimiento principal de _MSYSMENU (ObjType:1, ObjCode:22)
				IF NOT EMPTY(loHeader.PROCEDURE)
					lcExpr		= loHeader.PROCEDURE
					THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, '', 1, .T. )

					IF EMPTY(lcProcCode)
						*-- Comando
						lcText	= lcText + 'ON SELECTION MENU ' + loBarPop.NAME + ' ' + lcExpr + CR_LF
					ELSE
						*-- Procedure
						lcProcName	= EVL( lcProcName, CHRTRAN('SELECTION MENU ' + loBarPop.NAME, ' ', '_') + '_FB2P' )
						lcText	= lcText + 'ON SELECTION MENU ' + loBarPop.NAME + ' DO ' + lcProcName + CR_LF
						lcProcCode		= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )
						lcEndProcedures	= lcEndProcedures + lcProcCode + CR_LF
					ENDIF
				ENDIF

			CASE loHeader.ObjType = 4
				IF NOT EMPTY(loHeader.PROCEDURE)
					lcExpr		= loHeader.PROCEDURE
					THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, '', 1, .T. )

					IF EMPTY(lcProcCode)
						*-- Comando
						lcText	= lcText + 'ON SELECTION POPUP ALL ' + lcExpr + CR_LF
					ELSE
						*-- Procedure
						lcText	= lcText + 'ON SELECTION POPUP ALL ' + loBarPop.NAME + ' DO ' + lcProcName + CR_LF
						lcProcCode		= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )
						lcEndProcedures	= lcEndProcedures + lcProcCode + CR_LF
					ENDIF
				ENDIF

				lcText	= lcText + 'ACTIVATE POPUP ' + THIS.ITEM(1).ITEM(1).ITEM(1).oReg.NAME + CR_LF
			ENDCASE

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_MENUCODE_F>>
			ENDTEXT

			*-- Procedimientos finales
			IF NOT EMPTY(lcEndProcedures)
				lcText	= lcText + CR_LF + CR_LF ;
					+ C_PROC_CODE_I + CR_LF ;
					+ lcEndProcedures ;
					+ C_PROC_CODE_F + CR_LF
			ENDIF

			IF NOT EMPTY(loReg.Cleanup)
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
					<<C_CLEANUPCODE_I>>
					<<loReg.Cleanup>>
					<<C_CLEANUPCODE_F>>
				ENDTEXT
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE get_DataFromTablabin
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		*---------------------------------------------------------------------------------------------------
		LOCAL loReg, loCol_LastLevelName AS COLLECTION
		GO TOP
		SCATTER MEMO NAME loReg
		loCol_LastLevelName	= CREATEOBJECT('COLLECTION')
		CL_MENU_COL_BASE::get_DataFromTablabin( loReg, loCol_LastLevelName )
		STORE NULL TO loReg, loCol_LastLevelName
	ENDPROC


	PROCEDURE updateMENU
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		SELECT TABLABIN

		IF THIS.l_Debug
			toConversor.writeLog( '' )
			toConversor.writeLog( REPLICATE('-',80) )
		ENDIF

		THIS.UpdateMenu_Recursivo( THIS, 0, @toConversor )

		IF THIS.l_Debug
			toConversor.writeLog( REPLICATE('-',80) )
		ENDIF

	ENDPROC


	PROCEDURE UpdateMenu_Recursivo
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toObj						(v! IN    ) Referencia del objeto CL_MENU_BARPOP o CL_MENU_OPTION
		* tnNivel					(v! IN    ) Nivel de indentaci�n (solo para debug)
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toObj AS COLLECTION, tnNivel, toConversor
		LOCAL loReg, loEx AS EXCEPTION

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			IF VARTYPE( toObj.oReg ) = 'O'
				loReg	= toObj.oReg
				INSERT INTO TABLABIN FROM NAME loReg

				IF THIS.l_Debug
					toConversor.writeLog( REPLICATE(C_TAB,tnNivel) ;
						+ 'ObjType=' + TRANSFORM(loReg.ObjType) ;
						+ ', ObjCode=' + TRANSFORM(loReg.OBJCODE) ;
						+ ', Name=' + TRANSFORM(loReg.NAME) ;
						+ ', LevelName=' + TRANSFORM(loReg.LevelName) ;
						+ ', ItemNum=' + TRANSFORM(loReg.ITEMNUM) ;
						+ ', Location=' + TRANSFORM(loReg.Location) ;
						+ ', Prompt=' + TRANSFORM(loReg.PROMPT) ;
						+ ', Message=' + TRANSFORM(loReg.MESSAGE) ;
						+ ', KeyName=' + TRANSFORM(loReg.KEYNAME) ;
						+ ', KeyLabel=' + TRANSFORM(loReg.KeyLabel) ;
						+ ', Comment=' + TRANSFORM(loReg.COMMENT) ;
						+ ', SkipFor=' + TRANSFORM(loReg.SKIPFOR) )
				ENDIF

			ELSE
				IF THIS.l_Debug
					toConversor.writeLog( REPLICATE(C_TAB,tnNivel) ;
						+ 'Objeto [' + toObj.CLASS + '] sin registro oReg (nivel ' + TRANSFORM(tnNivel) + ')' )
				ENDIF

			ENDIF

			IF toObj.COUNT > 0 THEN
				FOR EACH loReg IN toObj FOXOBJECT
					THIS.UpdateMenu_Recursivo( loReg, tnNivel + 1, @toConversor )
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_MENU_BARPOP AS CL_MENU_COL_BASE
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_definepopup" display="analizarBloque_DefinePOPUP"/>] ;
		+ [<memberdata name="updatemenu" display="updateMENU"/>] ;
		+ [<memberdata name="c_parentname" display="c_ParentName"/>] ;
		+ [<memberdata name="n_parentcode" display="n_ParentCode"/>] ;
		+ [<memberdata name="n_parenttype" display="n_ParentType"/>] ;
		+ [</VFPData>]

	#IF .F.
		LOCAL THIS AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
	#ENDIF

	c_ParentName	= ''
	n_ParentCode	= 0
	n_ParentType	= 0


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loOption AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcSubName, lcComment, lnLast_I, loReg, lcExpr, lcProcName, lcProcCode, lcMenuType ;
				, loEx AS EXCEPTION
			STORE '' TO lcSubName, lcComment, lcExpr, lcProcName, lcProcCode

			THIS.oReg			= toConversor.emptyRecord()
			loReg				= THIS.oReg
			loReg.ObjType		= 2
			loReg.PROCTYPE		= 1
			loReg.MARK			= CHR(0)
			loReg.ITEMNUM		= STR(0,3)
			llBloqueEncontrado	= .T.

			FOR I = I + 0 TO tnCodeLines
				STORE '' TO lcExpr, lcProcName, lcProcCode
				THIS.set_Line( @tcLine, @taCodeLines, I )

				DO CASE
				CASE EMPTY( tcLine )
					LOOP

				CASE toConversor.lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
					LOOP	&& Saltear comentarios

				CASE LEFT( tcLine, LEN(C_MENUCODE_F) ) == C_MENUCODE_F
					EXIT

				CASE LEFT( tcLine, LEN('ON SELECTION POPUP ' + loReg.NAME) ) == 'ON SELECTION POPUP ' + loReg.NAME
					EXIT

				CASE LEFT( tcLine, 12 ) == 'DEFINE MENU '
					loReg.OBJCODE		= 1
					loReg.NAME			= STREXTRACT( tcLine, 'DEFINE MENU ', ' BAR' )
					*loReg.NAME			= '_MSYSMENU'
					loReg.LevelName		= loReg.NAME
					loReg.SCHEME		= IIF( loReg.OBJCODE = 1, 3, 4 )

					lcExpr			= STREXTRACT( C_FB2PRG_CODE, 'ON SELECTION POPUP ALL ', CR_LF )
					THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1 )
					loReg.PROCEDURE	= EVL(lcProcCode, lcExpr)

				CASE LEFT( tcLine, 13 ) == 'DEFINE POPUP '
					IF THIS.n_ParentCode = 22
						loReg.OBJCODE		= 1
						loReg.NAME			= '_MSYSMENU'
						loReg.LevelName		= loReg.NAME
						loReg.SCHEME		= 3

						IF THIS.n_ParentType = 4
							EXIT
						ENDIF
					ELSE
						loReg.OBJCODE		= 0
						loReg.SCHEME		= 4
						loReg.NAME			= ALLTRIM( GETWORDNUM( tcLine, 3 ) )
						IF RIGHT(loReg.NAME,5) == '_FB2P'	&& Originalmente era vac�o y se la hab�a puesto un nombre temporal.
							loReg.NAME		= ''
						ENDIF
						loReg.LevelName		= loReg.NAME
						lcExpr				= ALLTRIM( STREXTRACT( C_FB2PRG_CODE, 'ON SELECTION POPUP ' + loReg.NAME + ' ', CR_LF ) )
						THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1 )
						loReg.PROCEDURE		= EVL(lcProcCode, lcExpr)
					ENDIF

				CASE LEFT( tcLine, 11 ) == 'DEFINE PAD ' OR LEFT( tcLine, 11 ) == 'DEFINE BAR '
					loOption	= CREATEOBJECT("CL_MENU_OPTION")
					lnLast_I	= I
					loOption.c_ParentName	= loReg.LevelName
					loOption.n_ParentCode	= loReg.OBJCODE
					loOption.n_ParentType	= loReg.ObjType
					IF NOT loOption.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
						I = lnLast_I
						llBloqueEncontrado	= .F.
						EXIT
					ENDIF
					THIS.ADD( loOption )
					loOption.oReg.ITEMNUM	= STR(THIS.COUNT,3)
					loReg.NUMITEMS			= THIS.COUNT
					loReg.SCHEME			= IIF( loReg.OBJCODE = 1, 3, 4 )
					loOption	= NULL

				OTHERWISE	&& Otro valor
					I	= I - 1
					EXIT
				ENDCASE
			ENDFOR
			*ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			loOption	= NULL

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toParentReg				(v! IN    ) Objeto registro Padre
		* tnNivel					(v! IN    ) Nivel para indentar
		* tcEndProcedures			(@!    OUT) Agregar aqu� los procedimientos que ir�n al final
		* toHeader					(v! IN    ) Objeto Registro de cabecera del menu
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toParentReg, tnNivel, tcEndProcedures, toHeader

		TRY
			LOCAL loReg, I, lcText, lcTab, lcExpr, lcProcName, lcProcCode, loEx AS EXCEPTION ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG' ;
				, loOption AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'

			STORE '' TO lcText, lcExpr, lcProcName, lcProcCode
			loReg	= THIS.oReg
			lcTab	= REPLICATE(CHR(9),tnNivel)


			*-- Menu Bar or Popup (ObjType:2, ObjCode:0 � 1)
			IF loReg.OBJCODE = 0	&& (Menu Pad)
				IF toHeader.ObjType = 4
					*-- Shortcut
					IF NOT PEMSTATUS(toHeader,'_MenuInicializado', 5)	&& Header
						ADDPROPERTY(toHeader,'_MenuInicializado', .T.)
					ELSE	&& Rest
						TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
							<<lcTab>>*----------------------------------
							<<lcTab>>DEFINE POPUP <<loReg.Name>> SHORTCUT RELATIVE
						ENDTEXT
					ENDIF
				ELSE	&& ObjType = 1 � 5
					*-- Menu
					TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<lcTab>>*----------------------------------
						<<lcTab>>DEFINE POPUP <<loReg.Name>> MARGIN RELATIVE SHADOW COLOR SCHEME <<loReg.Scheme>>
					ENDTEXT
				ENDIF
			ENDIF

			*-- Options (ObjType:3)
			IF THIS.COUNT > 0
				FOR EACH loOption IN THIS FOXOBJECT
					lcText		= lcText + loOption.toText(loReg, tnNivel+0, @tcEndProcedures, toHeader)
				ENDFOR
			ENDIF

			*-- Procedure del POPUP o MENU
			IF NOT EMPTY(loReg.PROCEDURE)
				lcExpr		= loReg.PROCEDURE
				THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, '', 1, .T. )

				IF EMPTY(lcProcName)
					lcText			= lcText + lcTab + 'ON SELECTION POPUP ' + IIF( loReg.OBJCODE = 0, loReg.NAME, 'ALL' ) + ' ' + lcExpr + CR_LF
				ELSE
					lcText			= lcText + lcTab + 'ON SELECTION POPUP ' + IIF( loReg.OBJCODE = 0, loReg.NAME, 'ALL' ) + ' DO ' + lcProcName + CR_LF
					tcEndProcedures	= tcEndProcedures + STRTRAN( lcProcCode, '<<ProcName>>', lcProcName ) + CR_LF
				ENDIF

			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE updateMENU
	ENDPROC


ENDDEFINE


DEFINE CLASS CL_MENU_OPTION AS CL_MENU_COL_BASE
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_definebar" display="analizarBloque_DefineBAR"/>] ;
		+ [<memberdata name="analizarbloque_definepad" display="analizarBloque_DefinePAD"/>] ;
		+ [<memberdata name="get_definebartext" display="get_DefineBarText"/>] ;
		+ [<memberdata name="get_definepadtext" display="get_DefinePadText"/>] ;
		+ [<memberdata name="get_procnamefromsnippet" display="get_ProcNameFromSnippet"/>] ;
		+ [<memberdata name="c_parentname" display="c_ParentName"/>] ;
		+ [<memberdata name="n_parentcode" display="n_ParentCode"/>] ;
		+ [<memberdata name="n_parenttype" display="n_ParentType"/>] ;
		+ [</VFPData>]

	#IF .F.
		LOCAL THIS AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'
	#ENDIF

	c_ParentName	= ''
	n_ParentCode	= 0
	n_ParentType	= 0


	PROCEDURE analizarBloque
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
			LOCAL llBloqueEncontrado, lcComment, loReg, lnLast_I, loEx AS EXCEPTION ;
				, llPadOBar_Analizado
			STORE '' TO lcComment

			THIS.oReg		= toConversor.emptyRecord()
			loReg			= THIS.oReg
			loReg.MARK		= CHR(0)
			loReg.ITEMNUM	= STR(0,3)

			llBloqueEncontrado	= .T.

			FOR I = I + 0 TO tnCodeLines
				THIS.set_Line( @tcLine, @taCodeLines, I )

				DO CASE
				CASE EMPTY( tcLine )
					LOOP

				CASE toConversor.lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
					LOOP	&& Saltear comentarios

				CASE LEFT( tcLine, LEN(C_MENUCODE_F) ) == C_MENUCODE_F
					EXIT

				CASE LEFT( tcLine, LEN(C_MENUCODE_I) ) == C_MENUCODE_I
					loReg.ObjType = 2
					loReg.OBJCODE = 1

				CASE THIS.analizarBloque_DefinePAD( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					IF EMPTY(loReg.PROMPT)
						*-- Esta opci�n no corresponde a este nivel. Debe subir.
						llBloqueEncontrado = .F.
						EXIT
					ENDIF
					IF loReg.OBJCODE <> 77
						EXIT
					ENDIF

				CASE THIS.analizarBloque_DefineBAR( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
					IF EMPTY(loReg.PROMPT)
						*-- Esta opci�n no corresponde a este nivel. Debe subir.
						llBloqueEncontrado = .F.
						EXIT
					ENDIF
					IF loReg.OBJCODE <> 77
						EXIT
					ENDIF

				CASE LEFT( tcLine, 13 ) == 'DEFINE POPUP '
					loBarPop	= CREATEOBJECT("CL_MENU_BARPOP")
					lnLast_I	= I
					loBarPop.c_ParentName	= loReg.LevelName
					loBarPop.n_ParentCode	= loReg.OBJCODE
					loBarPop.n_ParentType	= loReg.ObjType
					THIS.ADD( loBarPop )
					IF NOT loBarPop.analizarBloque( @tcLine, @taCodeLines, @I, tnCodeLines, toConversor )
						I	= I - 1
					ENDIF
					loBarPop	= NULL
					EXIT

				OTHERWISE	&& Otro valor
					I	= I - 1
					EXIT
				ENDCASE
			ENDFOR

		CATCH TO loEx WHEN loEx.MESSAGE = 'Nivel_Anterior'
			*-- OK. Volver a evaluar en el nivel anterior
			llBloqueEncontrado	= .F.

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			loBarPop	= NULL
		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_DefinePAD
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcText, loReg, lnPos, lcPadName, lcExpr, lcComment, lcProcName, lcProcCode, loEx AS EXCEPTION ;
				, lnNegContainer, lnNegObject
			STORE '' TO lcText, lcComment, lcPadName

			* Estructura ejemplo a analizar:
			*--------------------------------
			*		DEFINE PAD _3YM1DR90Z OF _MSYSMENU PROMPT "Opci�n A con submen�" COLOR SCHEME 3 ;
			*			NEGOTIATE NONE, LEFT ;
			*			KEY DEL, "Pulsar <DEL>" ;
			*			SKIP FOR SKIP_FOR() ;
			*			MESSAGE "Mensaje para Opci�n A con submen�" && Comentario
			*
			*		ON PAD _3YM1DR90Z OF _MSYSMENU ACTIVATE POPUP Opci�nA_CS
			*--------------------------------
			IF LEFT( tcLine, 11 ) == 'DEFINE PAD '
				llBloqueEncontrado	= .T.
				loReg				= THIS.oReg
				loReg.ObjType		= 3
				lcPadName			= ALLTRIM( STREXTRACT( tcLine, 'PAD ' , ' OF' ) )
				loReg.NAME			= lcPadName
				loReg.LevelName		= ALLTRIM( STREXTRACT( tcLine, ' OF ', ' PROMPT ' ) )

				IF UPPER(loReg.LevelName) # UPPER(THIS.c_ParentName)
					EXIT
				ENDIF

				loReg.PROMPT		= CHRTRAN( ALLTRIM( STREXTRACT( tcLine, ' PROMPT ', ' COLOR ' ) ), '"', '' )

				*-- ANALISIS DEL "DEFINE PAD"
				IF ';' $ tcLine
					FOR I = I + 1 TO tnCodeLines
						THIS.set_Line( @tcLine, @taCodeLines, I )

						IF EMPTY(loReg.COMMENT)	&& No volver a buscar el comentario si ya existe
							lnPos	= AT( '&'+'&', tcLine )
							IF lnPos > 0
								*-- Busco si tiene comentario
								loReg.COMMENT	= SUBSTR( tcLine, lnPos + 3 )
								tcLine	= LEFT( tcLine, lnPos - 1 )
								lnPos	= 0
							ENDIF
						ENDIF

						DO CASE
						CASE LEFT( tcLine, 10 ) == 'NEGOTIATE '
							lcExpr	= ALLTRIM( STREXTRACT( tcLine, 'NEGOTIATE ', ';', 1, 2 ) )
							lnNegContainer	= INT( AT( ',' + PADR( ALLTRIM(GETWORDNUM( lcExpr, 1, ',' )), 6, '_' ) ;
								, '______,NONE__,LEFT__,MIDDLE,RIGHT_' ) / 7 - 1 )
							lnNegObject		= INT( AT( ',' + PADR( ALLTRIM(GETWORDNUM( lcExpr, 2, ',' )), 6, '_' ) ;
								, '______,NONE__,LEFT__,MIDDLE,RIGHT_' ) / 7 - 1 )
							loReg.Location	= lnNegContainer + lnNegObject * 2^4

						CASE LEFT( tcLine, 4 ) == 'KEY '
							lcExpr	= ALLTRIM( STREXTRACT( tcLine, 'KEY ', ';', 1, 2 ) )
							lnPos	= AT( ',', lcExpr )
							loReg.KEYNAME	= ALLTRIM( LEFT( lcExpr, lnPos-1 ) )
							loReg.KeyLabel	= ALLTRIM( STREXTRACT( lcExpr, '"', '"' ) )

						CASE LEFT( tcLine, 9 ) == 'SKIP FOR '
							loReg.SKIPFOR	= ALLTRIM( STREXTRACT( tcLine, 'SKIP FOR ', ';', 1, 2 ) )

						CASE LEFT( tcLine, 8 ) == 'MESSAGE '
							loReg.MESSAGE	= ALLTRIM( STREXTRACT( tcLine, '"', '"', 1, 4 ) )

						CASE LEFT( tcLine, 8 ) == 'PICTURE '
							loReg.RESNAME	= ALLTRIM( STREXTRACT( tcLine, '"', '"' ) )

						CASE LEFT( tcLine, 8 ) == 'PICTRES '
							loReg.RESNAME	= ALLTRIM( STREXTRACT( tcLine, 'PICTRES ', ';', 1, 2 ) )
							loReg.SYSRES	= 1

						OTHERWISE
							* Nada
						ENDCASE

						IF NOT ';' $ tcLine	&& Fin
							EXIT
						ENDIF
					ENDFOR
				ENDIF	&& ';' $ tcLine


				* Estructuras ejemplo a analizar:
				*--------------------------------
				*	ON PAD _3YM1DR90Z OF _MSYSMENU ACTIVATE POPUP Opci�nA_CS
				*	ON PAD _3YM1DR90Z OF _MSYSMENU wait window "algo"
				*	ON PAD _3YM1DR90Z OF _MSYSMENU DO Menu1_Opci�n_A_2_Sub_SNIPPET
				*--------------------------------

				*-- ANALISIS DEL "ON PAD" u "ON SELECTION PAD"
				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE LEFT( tcLine, 7 ) == 'ON PAD '
						loReg.OBJCODE	= 77	&& Submenu

						I = I + 1
						EXIT

					CASE LEFT( tcLine, 17 ) == 'ON SELECTION PAD '
						lcExpr	= ALLTRIM( STREXTRACT( tcLine, ' OF ' + loReg.LevelName + ' ', '', 1, 2 ) )
						THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1, .F. )

						DO CASE
						CASE EMPTY(lcProcCode)
							loReg.OBJCODE	= 67
							loReg.COMMAND	= lcExpr

						OTHERWISE
							loReg.PROCEDURE	= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )

							IF EMPTY( loReg.PROCEDURE )
								loReg.OBJCODE	= 67
								loReg.COMMAND	= lcExpr
							ELSE
								loReg.OBJCODE	= 80
								loReg.PROCTYPE	= 1
							ENDIF

						ENDCASE

						I = I + 1
						EXIT

					OTHERWISE
						* Nada
					ENDCASE

					IF NOT ';' $ tcLine	&& Fin
						I = I + 1
						EXIT
					ENDIF
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE analizarBloque_DefineBAR
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tcLine					(@! IN/OUT) Contenido de la l�nea en an�lisis
		* taCodeLines				(@! IN    ) Array de l�neas del programa analizado
		* I							(@! IN/OUT) N�mero de l�nea en an�lisis
		* tnCodeLines				(@! IN    ) Cantidad de l�neas del programa analizado
		* toConversor				(v! IN    ) Referencia al conversor para poder usar sus m�todos
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcLine, taCodeLines, I, tnCodeLines, toConversor

		#IF .F.
			LOCAL toConversor AS c_conversor_prg_a_mnx OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcText, loReg, lnPos, lcBarName, lcExpr, lcComment, lcProcName, lcProcCode, loEx AS EXCEPTION ;
				, lnNegContainer, lnNegObject
			STORE '' TO lcText, lcComment, lcBarName

			* Estructura ejemplo a analizar:
			*--------------------------------
			*		DEFINE BAR _3YM1DR90Z OF _MSYSMENU PROMPT "Opci�n A con submen�" COLOR SCHEME 3 ;
			*			NEGOTIATE NONE, LEFT ;
			*			KEY DEL, "Pulsar <DEL>" ;
			*			SKIP FOR SKIP_FOR() ;
			*			MESSAGE "Mensaje para Opci�n A con submen�" && Comentario
			*
			*		ON BAR _3YM1DR90Z OF _MSYSMENU ACTIVATE POPUP Opci�nA_CS
			*
			*		DEFINE BAR 1 OF _MSYSMENU PROMPT "Opci�n A con submen�" ;
			*			NEGOTIATE NONE, LEFT ;
			*			KEY DEL, "Pulsar <DEL>" ;
			*			SKIP FOR SKIP_FOR() ;
			*			MESSAGE "Mensaje para Opci�n A con submen�" && Comentario
			*
			*		ON BAR 1 OF _MSYSMENU ACTIVATE POPUP Opci�nA_CS
			*--------------------------------
			IF LEFT( tcLine, 11 ) == 'DEFINE BAR '
				llBloqueEncontrado	= .T.
				loReg				= THIS.oReg
				loReg.ObjType		= 3
				lcBarName			= ALLTRIM( STREXTRACT( tcLine, 'BAR ' , ' OF' ) )

				IF NOT ISDIGIT(lcBarName)
					*-- Es un BAR del sistema
					loReg.NAME	= lcBarName
				ENDIF

				loReg.LevelName		= ALLTRIM( STREXTRACT( tcLine, ' OF ', ' PROMPT ' ) )

				IF UPPER(loReg.LevelName) # UPPER(THIS.c_ParentName)
					EXIT
				ENDIF

				loReg.PROMPT		= CHRTRAN( ALLTRIM( STREXTRACT( tcLine, ' PROMPT ', ';', 1, 2 ) ), '"', '' )

				*-- ANALISIS DEL "DEFINE BAR"
				IF ';' $ tcLine
					FOR I = I + 1 TO tnCodeLines
						THIS.set_Line( @tcLine, @taCodeLines, I )

						IF EMPTY(loReg.COMMENT)	&& No volver a buscar el comentario si ya existe
							lnPos	= AT( '&'+'&', tcLine )
							IF lnPos > 0
								*-- Busco si tiene comentario
								loReg.COMMENT	= SUBSTR( tcLine, lnPos + 3 )
								tcLine	= LEFT( tcLine, lnPos - 1 )
								lnPos	= 0
							ENDIF
						ENDIF

						DO CASE
						CASE LEFT( tcLine, 10 ) == 'NEGOTIATE '
							lcExpr	= ALLTRIM( STREXTRACT( tcLine, 'NEGOTIATE ', ';', 1, 2 ) )
							lnNegContainer	= INT( AT( ',' + PADR( ALLTRIM(GETWORDNUM( lcExpr, 1, ',' )), 6, '_' ) ;
								, '______,NONE__,LEFT__,MIDDLE,RIGHT_' ) / 7 - 1 )
							lnNegObject		= INT( AT( ',' + PADR( ALLTRIM(GETWORDNUM( lcExpr, 2, ',' )), 6, '_' ) ;
								, '______,NONE__,LEFT__,MIDDLE,RIGHT_' ) / 7 - 1 )
							loReg.Location	= lnNegContainer + lnNegObject * 2^4

						CASE LEFT( tcLine, 4 ) == 'KEY '
							lcExpr	= ALLTRIM( STREXTRACT( tcLine, 'KEY ', ';', 1, 2 ) )
							lnPos	= AT( ',', lcExpr )
							loReg.KEYNAME	= ALLTRIM( LEFT( lcExpr, lnPos-1 ) )
							loReg.KeyLabel	= ALLTRIM( STREXTRACT( lcExpr, '"', '"' ) )

						CASE LEFT( tcLine, 9 ) == 'SKIP FOR '
							loReg.SKIPFOR	= ALLTRIM( STREXTRACT( tcLine, 'SKIP FOR ', ';', 1, 2 ) )

						CASE LEFT( tcLine, 8 ) == 'MESSAGE '
							loReg.MESSAGE	= ALLTRIM( STREXTRACT( tcLine, '"', '"', 1, 4 ) )

						CASE LEFT( tcLine, 8 ) == 'PICTURE '
							loReg.RESNAME	= ALLTRIM( STREXTRACT( tcLine, '"', '"' ) )

						CASE LEFT( tcLine, 8 ) == 'PICTRES '
							loReg.RESNAME	= ALLTRIM( STREXTRACT( tcLine, 'PICTRES ', ';', 1, 2 ) )
							loReg.SYSRES	= 1

						OTHERWISE
							* Nada
						ENDCASE

						IF NOT ';' $ tcLine	&& Fin
							EXIT
						ENDIF
					ENDFOR
				ENDIF	&& ';' $ tcLine

				IF LEFT(lcBarName,1) == '_'
					*-- Es un BAR del Sistema, as� que no tiene ON BAR ni nada m�s.
					loReg.OBJCODE	= 78	&& Bar#
					I = I + 1
					EXIT
				ENDIF


				* Estructuras ejemplo a analizar:
				*--------------------------------
				*	ON BAR _3YM1DR90Z OF _MSYSMENU ACTIVATE POPUP Opci�nA_CS
				*	ON BAR _3YM1DR90Z OF _MSYSMENU wait window "algo"
				*	ON BAR _3YM1DR90Z OF _MSYSMENU DO Menu1_Opci�n_A_2_Sub_SNIPPET
				*--------------------------------

				*-- ANALISIS DEL "ON BAR" u "ON SELECTION BAR"
				FOR I = I + 1 TO tnCodeLines
					THIS.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE EMPTY( tcLine )
						LOOP

					CASE LEFT( tcLine, 7 ) == 'ON BAR '
						loReg.OBJCODE	= 77	&& Submenu

						I = I + 1
						EXIT

					CASE LEFT( tcLine, 17 ) == 'ON SELECTION BAR '
						lcExpr	= ALLTRIM( STREXTRACT( tcLine, ' OF ' + loReg.LevelName + ' ', '', 1, 2 ) )
						THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, @C_FB2PRG_CODE, -1, .F. )

						DO CASE
						CASE NOT EMPTY(lcProcCode)
							loReg.PROCEDURE	= STRTRAN( lcProcCode, '<<ProcName>>', lcProcName )

							IF EMPTY( loReg.PROCEDURE )
								loReg.OBJCODE	= 67
								loReg.COMMAND	= lcExpr
							ELSE
								loReg.OBJCODE	= 80
								loReg.PROCTYPE	= 1
							ENDIF

						OTHERWISE
							loReg.OBJCODE	= 67	&& Command
							loReg.COMMAND	= lcExpr

						ENDCASE

						I = I + 1
						EXIT

					OTHERWISE
						* Nada
					ENDCASE

					IF NOT ';' $ tcLine	&& Fin
						I = I + 1
						EXIT
					ENDIF
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toParentReg				(v? IN    ) Objeto registro Padre
		* tnNivel					(v? IN    ) Nivel para indentar
		* tcEndProcedures			(@!    OUT) Agregar aqu� los procedimientos que ir�n al final
		* toHeader					(v! IN    ) Objeto Registro de cabecera del menu
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toParentReg, tnNivel, tcEndProcedures, toHeader

		TRY
			LOCAL loReg, I, lcText, lcTab, lcExpr, lcProcName, lcProcCode, loEx AS EXCEPTION ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG' ;
				, loOption AS CL_MENU_OPTION OF 'FOXBIN2PRG.PRG'

			lcText		= ''
			lcProcName	= ''
			loReg		= THIS.oReg
			lcTab		= REPLICATE(CHR(9),tnNivel)
			loBarPop	= toParentReg

			*-- Options (ObjType:3)
			DO CASE
			CASE toParentReg.ObjType = 2 AND toParentReg.OBJCODE = 0
				*-- Define Bar
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<THIS.get_DefineBarText(loReg, loBarPop, tnNivel, toHeader)>>
				ENDTEXT

			CASE toParentReg.ObjType = 2 AND toParentReg.OBJCODE = 1 AND (toHeader.ObjType = 1 OR toHeader.ObjType = 5)
				*-- Define Pad
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<THIS.get_DefinePadText(loReg, loBarPop, tnNivel, toHeader)>>
				ENDTEXT

			ENDCASE

			IF loReg.OBJCODE = 80	&& Procedure de BAR o PAD
				*-- Reemplazo el nombre definitivo
				lcExpr		= loReg.PROCEDURE
				THIS.AnalizarSiExpresionEsComandoOProcedimiento( lcExpr, @lcProcName, @lcProcCode, '', 1, .T. )

				IF EMPTY(lcProcName)
					lcProcName	= CHRTRAN( ALLTRIM( STREXTRACT( lcText, 'DEFINE ', 'PROMPT ' ) ), ' ', '_' ) + '_FB2P'
				ENDIF

				lcText			= STRTRAN( lcText, '<<ProcName>>', lcProcName )
				tcEndProcedures	= tcEndProcedures + STRTRAN( lcProcCode, '<<ProcName>>', lcProcName ) + CR_LF
			ENDIF


			*-- Menu Bar or Popup (ObjType:2, ObjCode:0 � 1)
			IF THIS.COUNT > 0
				FOR EACH loBarPop IN THIS FOXOBJECT
					IF toParentReg.ObjType = 2 AND toParentReg.OBJCODE = 1 AND toHeader.ObjType = 4
						*-- Shortcut
						lcText		= lcText + loBarPop.toText(loReg, tnNivel + 0, @tcEndProcedures, toHeader)
					ELSE
						*-- Menu
						lcText		= lcText + loBarPop.toText(loReg, tnNivel + 1, @tcEndProcedures, toHeader)
					ENDIF
				ENDFOR
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE get_DefineBarText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toReg						(v? IN    ) Objeto registro
		* toBarPop					(v? IN    ) Bar o Popup hijo
		* tnNivel					(v? IN    ) Nivel para indentar
		* toHeader					(v! IN    ) Objeto Registro de cabecera del menu
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toReg, toBarPop, tnNivel, toHeader

		TRY
			LOCAL lcText, lcTab, loEx AS EXCEPTION ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
			lcTab		= REPLICATE(CHR(9),tnNivel)
			lcText		= ''

			*-- DEFINE BAR
			*lcText	= lcTab + '*----------------------------------' + CR_LF
			lcText	= lcText + lcTab + 'DEFINE BAR ' + ALLTRIM( EVL( toReg.NAME, toReg.ITEMNUM ) ) + ' OF ' + ALLTRIM(toReg.LevelName) ;
				+ ' PROMPT "' + toReg.PROMPT + '"'

			IF NOT EMPTY(toReg.KEYNAME)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	KEY ' + toReg.KEYNAME + ', "' + toReg.KeyLabel + '"'
			ENDIF

			IF NOT EMPTY(toReg.SKIPFOR)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	SKIP FOR ' + toReg.SKIPFOR
			ENDIF

			IF NOT EMPTY(toReg.RESNAME)
				IF toReg.SYSRES = 1
					lcText	= lcText + ' ;' + CR_LF + lcTab + '	PICTRES ' + toReg.RESNAME
				ELSE
					lcText	= lcText + ' ;' + CR_LF + lcTab + '	PICTURE "' + toReg.RESNAME + '"'
				ENDIF
			ENDIF

			IF NOT EMPTY(toReg.MESSAGE)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	MESSAGE ' + toReg.MESSAGE
			ENDIF

			IF NOT EMPTY(toReg.COMMENT)
				lcText	= lcText + ' &' + '& ' + toReg.COMMENT
			ENDIF

			*-- ON BAR
			IF toReg.OBJCODE <> 78	&& Bar#
				lcText	= lcText + CR_LF

				IF toReg.OBJCODE = 77	&& Submenu
					loBarPop	= THIS.ITEM(1).oReg
					lcText	= lcText + lcTab + 'ON BAR ' + ALLTRIM( EVL( toReg.NAME, toReg.ITEMNUM ) ) + ' OF ' + ALLTRIM(toReg.LevelName) ;
						+ ' ACTIVATE POPUP ' + ALLTRIM(loBarPop.NAME)
				ELSE
					lcText	= lcText + lcTab + 'ON SELECTION BAR ' + ALLTRIM( EVL( toReg.NAME, toReg.ITEMNUM ) ) + ' OF ' + ALLTRIM(toReg.LevelName)

					DO CASE
					CASE toReg.OBJCODE = 67	&& Command
						IF NOT EMPTY(toReg.COMMAND)
							lcText	= lcText + ' ' + ALLTRIM(toReg.COMMAND)
						ENDIF
					CASE toReg.OBJCODE = 80	&& Procedure
						IF NOT EMPTY(toReg.PROCEDURE)
							lcText	= lcText + ' DO <<ProcName>>'
						ENDIF
					ENDCASE
				ENDIF
			ENDIF

			lcText	= lcText + CR_LF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE get_DefinePadText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* toReg						(v? IN    ) Objeto registro
		* toBarPop					(v? IN    ) Bar o Popup hijo
		* tnNivel					(v? IN    ) Nivel para indentar
		* toHeader					(v! IN    ) Objeto Registro de cabecera del menu
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS toReg, toBarPop, tnNivel, toHeader

		TRY
			LOCAL lcText, lcTab, lnContainer, lnObject, loEx AS EXCEPTION ;
				, loBarPop AS CL_MENU_BARPOP OF 'FOXBIN2PRG.PRG'
			lcTab		= REPLICATE(CHR(9),tnNivel)
			toReg.NAME	= EVL(toReg.NAME,SYS(2015))
			lcText		= ''

			*-- DEFINE PAD
			*lcText	= lcTab + '*----------------------------------' + CR_LF
			lcText	= lcText + lcTab + 'DEFINE PAD ' + ALLTRIM(toReg.NAME) + ' OF ' + ALLTRIM(toReg.LevelName) ;
				+ ' PROMPT "' + toReg.PROMPT + '"' ;
				+ ' COLOR SCHEME ' + TRANSFORM(toBarPop.SCHEME)

			IF NOT EMPTY(toReg.Location)
				lnContainer	= toReg.Location % 2^4
				lnObject	= INT( (toReg.Location - lnContainer) / 2^4 )
				lcText		= lcText + ' ;' + CR_LF + lcTab + '	NEGOTIATE ' + GETWORDNUM('NONE,LEFT,MIDDLE,RIGHT',lnContainer+1,',') ;
					+ ', ' + GETWORDNUM('NONE,LEFT,MIDDLE,RIGHT',lnObject+1,',')
			ENDIF

			IF NOT EMPTY(toReg.KEYNAME)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	KEY ' + toReg.KEYNAME + ', "' + toReg.KeyLabel + '"'
			ENDIF

			IF NOT EMPTY(toReg.SKIPFOR)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	SKIP FOR ' + toReg.SKIPFOR
			ENDIF

			IF NOT EMPTY(toReg.RESNAME)
				IF toReg.SYSRES = 1
					lcText	= lcText + ' ;' + CR_LF + lcTab + '	PICTRES ' + toReg.RESNAME
				ELSE
					lcText	= lcText + ' ;' + CR_LF + lcTab + '	PICTURE "' + toReg.RESNAME + '"'
				ENDIF
			ENDIF

			IF NOT EMPTY(toReg.MESSAGE)
				lcText	= lcText + ' ;' + CR_LF + lcTab + '	MESSAGE ' + toReg.MESSAGE
			ENDIF

			IF NOT EMPTY(toReg.COMMENT)
				lcText	= lcText + ' &' + '& ' + toReg.COMMENT
			ENDIF

			lcText	= lcText + CR_LF

			*-- ON PAD
			IF toReg.OBJCODE <> 78	&& Bar#
				lcText	= lcText + CR_LF

				IF toReg.OBJCODE = 77	&& Submenu
					loBarPop	= THIS.ITEM(1).oReg
					lcText	= lcText + lcTab + 'ON PAD ' + ALLTRIM(toReg.NAME) + ' OF ' + ALLTRIM(toReg.LevelName) ;
						+ ' ACTIVATE POPUP ' + ALLTRIM(loBarPop.NAME)
				ELSE
					lcText	= lcText + lcTab + 'ON SELECTION PAD ' + ALLTRIM(toReg.NAME) + ' OF ' + ALLTRIM(toReg.LevelName)

					DO CASE
					CASE toReg.OBJCODE = 67	&& Command
						IF NOT EMPTY(toReg.COMMAND)
							lcText	= lcText + ' ' + ALLTRIM(toReg.COMMAND)
						ENDIF
					CASE toReg.OBJCODE = 80	&& Procedure
						IF NOT EMPTY(toReg.PROCEDURE)
							lcText	= lcText + ' DO <<ProcName>>'
						ENDIF
					ENDCASE
				ENDIF
			ENDIF

			lcText	= lcText + CR_LF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


	PROCEDURE updateMENU
	ENDPROC


ENDDEFINE


DEFINE CLASS CL_DBF_UTILS AS SESSION
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="fields" display="Fields"/>] ;
		+ [<memberdata name="c_backlink_dbc_name" display="c_Backlink_DBC_Name"/>] ;
		+ [<memberdata name="c_filename" display="c_FileName"/>] ;
		+ [<memberdata name="n_headersize" display="n_HeaderSize"/>] ;
		+ [<memberdata name="n_filesize" display="n_FileSize"/>] ;
		+ [<memberdata name="c_lastupdate" display="c_LastUpdate"/>] ;
		+ [<memberdata name="l_debug" display="l_Debug"/>] ;
		+ [<memberdata name="l_filehascdx" display="l_FileHasCDX"/>] ;
		+ [<memberdata name="l_fileisdbc" display="l_FileIsDBC"/>] ;
		+ [<memberdata name="l_filehasmemo" display="l_FileHasMemo"/>] ;
		+ [<memberdata name="n_codepage" display="n_CodePage"/>] ;
		+ [<memberdata name="c_codepagedesc" display="c_CodePageDesc"/>] ;
		+ [<memberdata name="n_datarecordlength" display="n_DataRecordLength"/>] ;
		+ [<memberdata name="n_fieldcount" display="n_FieldCount"/>] ;
		+ [<memberdata name="n_hexfiletype" display="n_HexFileType"/>] ;
		+ [<memberdata name="n_numberofrecords" display="n_NumberOfRecords"/>] ;
		+ [<memberdata name="n_numberofrecordsreal" display="n_NumberOfRecordsReal"/>] ;
		+ [<memberdata name="n_posoffirstdatarecord" display="n_PosOfFirstDataRecord"/>] ;
		+ [<memberdata name="filetypedescription" display="fileTypeDescription"/>] ;
		+ [<memberdata name="getcodepageinfo" display="getCodePageInfo"/>] ;
		+ [<memberdata name="getdbfmetadata" display="getDBFmetadata"/>] ;
		+ [<memberdata name="totext" display="toText"/>] ;
		+ [<memberdata name="write_dbc_backlink" display="write_DBC_BackLink"/>] ;
		+ [</VFPData>]

	#IF .F.
		LOCAL THIS AS CL_DBF_UTILS OF 'FOXBIN2PRG.PRG'
	#ENDIF

	l_Debug					= .F.
	c_Backlink_DBC_Name		= ''
	c_FileName				= ''
	n_FileSize				= 0
	n_HeaderSize			= 0
	c_LastUpdate			= ''
	l_FileHasCDX			= .F.
	l_FileIsDBC				= .F.
	l_FileHasMemo			= .F.
	n_CodePage				= 0
	c_CodePageDesc			= ''
	n_DataRecordLength		= 0
	n_HexFileType			= 0
	n_FieldCount			= 0
	n_NumberOfRecords		= 0
	n_NumberOfRecordsReal	= 0
	n_PosOfFirstDataRecord	= 0
	FIELDS					= NULL


	PROCEDURE INIT
		THIS.FIELDS = CREATEOBJECT("COLLECTION")
	ENDPROC


	PROCEDURE getDBFmetadata
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_FileName				(v! IN    ) Nombre del DBF a analizar
		* tn_HexFileType			(@?    OUT) Tipo de archivo en hexadecimal (Est� detallado en la ayuda de Fox)
		* tl_FileHasCDX				(@?    OUT) Indica si el archivo tiene CDX asociado
		* tl_FileHasMemo			(@?    OUT) Indica si el archivo tiene archivo MEMO asociado
		* tl_FileIsDBC				(@?    OUT) Indica si el archivo es un DBC (base de datos)
		* tcDBC_Name				(@?    OUT) Si tiene DBC, contiene el nombre del DBC asociado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_FileName, tn_HexFileType, tl_FileHasCDX, tl_FileHasMemo, tl_FileIsDBC, tcDBC_Name

		TRY
			LOCAL lnHandle, lcStr, lnDataPos, lnFieldCount, lnVal, I, loEx AS EXCEPTION ;
				, lnCodePage, lcCodePageDesc ;
				, loField AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG'

			tn_HexFileType	= 0
			tcDBC_Name		= ''
			lnHandle		= FOPEN(tc_FileName,0)

			IF lnHandle = -1
				EXIT
			ENDIF

			*										   				Bytes		Description
			*------------------------------------------------------ -----------	------------------------------------------
			WITH THIS AS CL_DBF_UTILS OF 'FOXBIN2PRG.PRG'
				.c_FileName					= tc_FileName
				lcStr						= FREAD(lnHandle,1)		&& 0		File type
				tn_HexFileType				= EVALUATE( TRANSFORM(ASC(lcStr),'@0') )
				.n_HexFileType				= tn_HexFileType
				lcStr						= FREAD(lnHandle,3)		&& 1-3		Last update (YYMMDD)
				.c_LastUpdate				= PADL(ASC(LEFT(lcStr,1)),2,'0') + '/' + PADL(ASC(SUBSTR(lcStr,2,1)),2,'0') + '/' + PADL(ASC(RIGHT(lcStr,1)),2,'0')
				lcStr						= FREAD(lnHandle,4)		&& 4-7		Number of records in file
				.n_NumberOfRecords			= CTOBIN(lcStr,"4RS")
				lcStr						= FREAD(lnHandle,2)		&& 8-9		Position of first data record
				.n_PosOfFirstDataRecord		= CTOBIN(lcStr,"2RS")
				.n_HeaderSize				= INT(.n_PosOfFirstDataRecord + 1)
				IF INLIST(tn_HexFileType, 0x30, 0x31, 0x32) THEN
					.n_FieldCount	= INT( (.n_PosOfFirstDataRecord - 296) / 32 )	&& Visual FoxPro
				ELSE
					.n_FieldCount	= INT( (.n_PosOfFirstDataRecord - 33) / 32 )
				ENDIF
				lcStr						= FREAD(lnHandle,2)		&& 10-11	Length of one data record, including delete flag
				.n_DataRecordLength			= CTOBIN(lcStr,"2RS")
				lcStr						= FREAD(lnHandle,16)	&& 16-27	Reserved
				lcStr						= FREAD(lnHandle,1)		&& 28		Table flags: 0x01=Has CDX, 0x02=Has Memo, 0x04=Id DBC (flags acumulativos)
				.l_FileHasCDX				= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x01 ) > 0 )
				.l_FileHasMemo				= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x02 ) > 0 )
				.l_FileIsDBC				= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x04 ) > 0 )
				lcStr						= FREAD(lnHandle,1)		&& 29		Code page mark (0=, 2=850,3=1252)
				lnVal						= EVALUATE( TRANSFORM(ASC(lcStr),'@0') )
				.getCodePageInfo( lnVal, @lnCodePage, @lcCodePageDesc )
				.n_CodePage					= lnCodePage
				.c_CodePageDesc				= lcCodePageDesc
				lcStr						= FREAD(lnHandle,2)		&& 30-31	Reserved, contains 0x00
				*lcStr						= FREAD(lnHandle,32 * lnFieldCount)	&& 32-n			Field subrecords (los salteo)
				*---
				FOR I = 1 TO .n_FieldCount
					loField	= CREATEOBJECT("CL_DBF_UTILS_FIELD")

					WITH loField AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG'
						lcStr						= FREAD(lnHandle,11)
						.FieldName					= RTRIM( lcStr, 0, CHR(0), ' ' )
						lcStr						= FREAD(lnHandle,1)
						.FieldType					= lcStr
						lcStr						= FREAD(lnHandle,4)
						.FieldDisplacementInRecord	= CTOBIN(lcStr,"4RS")
						lcStr						= FREAD(lnHandle,1)
						.FieldWidth					= ASC(lcStr)
						lcStr						= FREAD(lnHandle,1)
						.FieldDecimals				= ASC(lcStr)
						lcStr						= FREAD(lnHandle,1)
						.FieldFlags					= ASC(lcStr)
						lcStr						= FREAD(lnHandle,4)
						.NextValueForAutoInc		= CTOBIN(lcStr,"4RS")
						lcStr						= FREAD(lnHandle,1)
						.StepForAutoInc				= ASC(lcStr)
						lcStr						= FREAD(lnHandle,8)
					ENDWITH

					.FIELDS.ADD(loField)
					loField	= NULL
				ENDFOR
				*---
				lcStr						= FREAD(lnHandle,1)		&& n+1			Header Record Terminator (0x0D)

				IF INLIST(tn_HexFileType, 0x30, 0x31, 0x32) THEN
					lcStr					= FREAD(lnHandle,263)	&& n+2 to n+264	Backlink (relative path of an associated database (.dbc) file)
					tcDBC_Name				= RTRIM(lcStr,0,CHR(0))	&& DBC Name (si tiene)
					.c_Backlink_DBC_Name	= tcDBC_Name
				ENDIF

				.n_FileSize				= FSEEK(lnHandle, 0, 2)
				.n_NumberOfRecordsReal	= INT( (.n_FileSize - .n_HeaderSize) / .n_DataRecordLength )
			ENDWITH

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			FCLOSE(lnHandle)
		ENDTRY

		RETURN lnHandle
	ENDPROC


	PROCEDURE fileTypeDescription
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tn_HexFileType			(@? IN    ) Tipo de archivo en hexadecimal (Est� detallado en la ayuda de Fox)
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tn_HexFileType
		LOCAL lcFileType

		DO CASE
		CASE tn_HexFileType = 0x02
			lcFileType	= 'FoxBASE / dBase II'
		CASE tn_HexFileType = 0x03
			lcFileType	= 'FoxBASE+ / FoxPro /dBase III PLUS / dBase IV, no memo'
		CASE tn_HexFileType = 0x30
			lcFileType	= 'Visual FoxPro'
		CASE tn_HexFileType = 0x31
			lcFileType	= 'Visual FoxPro, autoincrement enabled'
		CASE tn_HexFileType = 0x32
			lcFileType	= 'Visual FoxPro, Varchar, Varbinary, or Blob-enabled'
		CASE tn_HexFileType = 0x43
			lcFileType	= 'dBASE IV SQL table files, no memo'
		CASE tn_HexFileType = 0x63
			lcFileType	= 'dBASE IV SQL system files, no memo'
		CASE tn_HexFileType = 0x83
			lcFileType	= 'FoxBASE+/dBASE III PLUS, with memo'
		CASE tn_HexFileType = 0x8B
			lcFileType	= 'dBASE IV with memo'
		CASE tn_HexFileType = 0xCB
			lcFileType	= 'dBASE IV SQL table files, with memo'
		CASE tn_HexFileType = 0xF5
			lcFileType	= 'FoxPro 2.x (or earlier) with memo'
		CASE tn_HexFileType = 0xFB
			lcFileType	= 'FoxBASE (?)'
		OTHERWISE
			lcFileType	= 'Unknown'
		ENDCASE

		RETURN lcFileType
	ENDPROC


	PROCEDURE getCodePageInfo
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tnHexCodePage				(v! IN    ) C�digo de p�gina en hexadecimal (Est� detallado en la ayuda de Fox)
		* tnCodePage				(@?    OUT) C�digo de p�gina normal
		* tcDescrip					(@?    OUT) Descripci�n del c�digo de p�gina
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tnHexCodePage, tnCodePage, tcDescrip

		LOCAL laCodePage(27,3), lnPos
		*Code page  Platform  Code page identifier
		laCodePage( 1,1)	= 437
		laCodePage( 1,2)	= 'U.S. MS-DOS'
		laCodePage( 1,3)	= 0x01

		laCodePage( 2,1)	= 620
		laCodePage( 2,2)	= 'Mazovia (Polish) MS-DOS'
		laCodePage( 2,3)	= 0x69

		laCodePage( 3,1)	= 737
		laCodePage( 3,2)	= 'Greek MS-DOS (437G)'
		laCodePage( 3,3)	= 0x6A

		laCodePage( 4,1)	= 850
		laCodePage( 4,2)	= 'International MS-DOS'
		laCodePage( 4,3)	= 0x02

		laCodePage( 5,1)	= 852
		laCodePage( 5,2)	= 'Eastern European MS-DOS'
		laCodePage( 5,3)	= 0x64

		laCodePage( 6,1)	= 857
		laCodePage( 6,2)	= 'Turkish MS-DOS'
		laCodePage( 6,3)	= 0x6B

		laCodePage( 7,1)	= 861
		laCodePage( 7,2)	= 'Icelandic MS-DOS'
		laCodePage( 7,3)	= 0x67

		laCodePage( 8,1)	= 865
		laCodePage( 8,2)	= 'Nordic MS-DOS'
		laCodePage( 8,3)	= 0x66

		laCodePage( 9,1)	= 866
		laCodePage( 9,2)	= 'Russian MS-DOS'
		laCodePage( 9,3)	= 0x65

		laCodePage(10,1)	= 874
		laCodePage(10,2)	= 'Thai Windows'
		laCodePage(10,3)	= 0x7C

		laCodePage(12,1)	= 895
		laCodePage(12,2)	= 'Kamenicky (Czech) MS-DOS'
		laCodePage(12,3)	= 0x68

		laCodePage(13,1)	= 932
		laCodePage(13,2)	= 'Japanese Windows'
		laCodePage(13,3)	= 0x7B

		laCodePage(14,1)	= 936
		laCodePage(14,2)	= 'Chinese Simplified (PRC, Singapore) Windows'
		laCodePage(14,3)	= 0x7A

		laCodePage(15,1)	= 949
		laCodePage(15,2)	= 'Korean Windows'
		laCodePage(15,3)	= 0x79

		laCodePage(16,1)	= 950
		laCodePage(16,2)	= 'Traditional Chinese (Hong Kong SAR, Taiwan) Windows'
		laCodePage(16,3)	= 0x78

		laCodePage(17,1)	= 1250
		laCodePage(17,2)	= 'Eastern European Windows'
		laCodePage(17,3)	= 0xC8

		laCodePage(18,1)	= 1251
		laCodePage(18,2)	= 'Russian Windows'
		laCodePage(18,3)	= 0xC9

		laCodePage(19,1)	= 1252
		laCodePage(19,2)	= 'Windows ANSI'
		laCodePage(19,3)	= 0x03

		laCodePage(20,1)	= 1253
		laCodePage(20,2)	= 'Greek Windows'
		laCodePage(20,3)	= 0xCB

		laCodePage(21,1)	= 1254
		laCodePage(21,2)	= 'Turkish Windows'
		laCodePage(21,3)	= 0xCA

		laCodePage(22,1)	= 1255
		laCodePage(22,2)	= 'Hebrew Windows'
		laCodePage(22,3)	= 0x7D

		laCodePage(23,1)	= 1256
		laCodePage(23,2)	= 'Arabic Windows'
		laCodePage(23,3)	= 0x7E

		laCodePage(24,1)	= 10000
		laCodePage(24,2)	= 'Standard Macintosh'
		laCodePage(24,3)	= 0x04

		laCodePage(25,1)	= 10006
		laCodePage(25,2)	= 'Greek Macintosh'
		laCodePage(25,3)	= 0x98

		laCodePage(26,1)	= 10007
		laCodePage(26,2)	= 'Russian Macintosh'
		laCodePage(26,3)	= 0x96

		laCodePage(27,1)	= 10029
		laCodePage(27,2)	= 'Macintosh EE'
		laCodePage(27,3)	= 0x97

		lnPos	= ASCAN( laCodePage, tnHexCodePage, 1, -1, 3, 8 )

		IF lnPos > 0
			tnCodePage	= laCodePage(lnPos,1)
			tcDescrip	= laCodePage(lnPos,2)
		ELSE
			tnCodePage	= 0
			tcDescrip	= ''
		ENDIF

		RETURN
	ENDPROC


	PROCEDURE toText
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		*---------------------------------------------------------------------------------------------------
		LOCAL lcText, loField AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG'
		lcText	= ''

		WITH THIS AS CL_DBF_UTILS OF 'FOXBIN2PRG.PRG'
			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				---------------------------------------------------
				FileName                : <<JUSTFNAME(.c_FileName)>>
				---------------------------------------------------
				Backlink_DBC_Name       : <<.c_Backlink_DBC_Name>>
				HexFileType             : <<TRANSFORM(.n_HexFileType, '@0')>> - <<.fileTypeDescription(.n_HexFileType)>>
				FileSize                : <<.n_FileSize>> bytes
				LastUpdate              : <<.c_LastUpdate>>
				NumberOfRecords         : <<.n_NumberOfRecords>> - REAL: <<.n_NumberOfRecordsReal>>
				PosOfFirstDataRecord    : <<.n_PosOfFirstDataRecord>>
				FieldCount              : <<.n_FieldCount>>
				DataRecordLength        : <<.n_DataRecordLength>>
				FileHasCDX              : <<.l_FileHasCDX>>
				FileHasMemo             : <<.l_FileHasMemo>>
				FileIsDBC               : <<.l_FileIsDBC>>
				CodePage                : <<.n_CodePage>> - <<.c_CodePageDesc>>

				---------------------------------------------------
			ENDTEXT

			*-- Fields
			loField	= THIS.FIELDS.ITEM(1)
			lcText	= lcText + CR_LF + loField.toText(.T.)

			FOR EACH loField AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG' IN THIS.FIELDS
				lcText	= lcText + CR_LF + loField.toText()
			ENDFOR

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

				---------------------------------------------------
				Field flags Reference:
				0x01   System Column (not visible to user)
				0x02   Column can store null values
				0x04   Binary column (for CHAR and MEMO only)
				0x06   (0x02+0x04) When a field is NULL and binary (Integer, Currency, and Character/Memo fields)
				0x0C   Column is autoincrementing

			ENDTEXT

		ENDWITH

		RETURN lcText
	ENDPROC


	PROCEDURE write_DBC_BackLink
		*---------------------------------------------------------------------------------------------------
		* PAR�METROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
		* tc_FileName				(v! IN    ) Nombre del DBF a analizar
		* tcDBC_Name				(v! IN    ) Nombre del DBC a asociar
		* tdLastUpdate				(v! IN    ) Fecha de �ltima actualizaci�n
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_FileName, tcDBC_Name, tdLastUpdate

		TRY
			LOCAL lnHandle, ln_HexFileType, lcStr, lnDataPos, lnFieldCount, loEx AS EXCEPTION

			IF NOT EMPTY(tcDBC_Name)
				ln_HexFileType	= 0
				lnHandle		= FOPEN(tc_FileName,2)

				IF lnHandle = -1
					EXIT
				ENDIF

				lcStr			= FREAD(lnHandle,1)		&& File type
				ln_HexFileType	= EVALUATE( TRANSFORM(ASC(lcStr),'@0') )

				IF EMPTY(tdLastUpdate)
					lcStr	= FREAD(lnHandle,3)		&& Last update (YYMMDD)
				ELSE
					lcStr	= CHR( VAL( RIGHT( PADL( YEAR( tdLastUpdate ),4,'0'), 2 ) ) ) ;
						+ CHR( VAL( PADL( MONTH( tdLastUpdate ),2,'0' ) ) ) ;
						+ CHR( VAL( PADL( DAY( tdLastUpdate ),2,'0' ) ) )		&&	Last update (YYMMDD)
					=FWRITE( lnHandle, PADR(lcStr,3,CHR(0)) )
				ENDIF

				=FREAD(lnHandle,4)		&& Number of records in file
				lcStr			= FREAD(lnHandle,2)		&& Position of first data record
				lnDataPos		= CTOBIN(lcStr,"2RS")
				IF INLIST(ln_HexFileType, 0x30, 0x31, 0x32) THEN
					lnFieldCount	= (lnDataPos - 296) / 32
				ELSE
					EXIT	&& No DBC BackLink on older versions!
				ENDIF
				=FREAD(lnHandle,2)		&& Length of one data record, including delete flag
				=FREAD(lnHandle,16)		&& Reserved
				=FREAD(lnHandle,1)		&& Table flags: 0x01=Has CDX, 0x02=Has Memo, 0x04=Id DBC (flags acumulativos)
				=FREAD(lnHandle,1)		&& Code page mark
				=FREAD(lnHandle,2)		&& Reserved, contains 0x00
				=FREAD(lnHandle,32 * lnFieldCount)		&& Field subrecords (los salteo)
				=FREAD(lnHandle,1)		&& Header Record Terminator (0x0D)

				IF INLIST(ln_HexFileType, 0x30, 0x31, 0x32) THEN
					IF FWRITE( lnHandle, PADR(tcDBC_Name,263,CHR(0)) ) = 0
						*-- No se pudo actualizar el backlink [] de la tabla []
						ERROR C_BACKLINK_CANT_UPDATE_BL_LOC + ' [' + tcDBC_Name + '] ' + C_BACKLINK_OF_TABLE_LOC + ' [' + tc_FileName + ']'
					ENDIF
				ENDIF
			ENDIF


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			FCLOSE(lnHandle)
		ENDTRY

		RETURN lnHandle
	ENDPROC


ENDDEFINE


DEFINE CLASS CL_DBF_UTILS_FIELD AS CUSTOM
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="fieldname" display="FieldName"/>] ;
		+ [<memberdata name="fieldtype" display="FieldType"/>] ;
		+ [<memberdata name="fieldwidth" display="FieldWidth"/>] ;
		+ [<memberdata name="fielddecimals" display="FieldDecimals"/>] ;
		+ [<memberdata name="fieldflags" display="FieldFlags"/>] ;
		+ [<memberdata name="fielddisplacementinrecord" display="FieldDisplacementInRecord"/>] ;
		+ [<memberdata name="allownulls" display="AllowNulls"/>] ;
		+ [<memberdata name="nocodepagetranslation" display="NoCodePageTranslation"/>] ;
		+ [<memberdata name="fieldvalidationexpression" display="FieldValidationExpression"/>] ;
		+ [<memberdata name="fieldvalidationtext" display="FieldValidationText"/>] ;
		+ [<memberdata name="fielddefaultvalue" display="FieldDefaultValue"/>] ;
		+ [<memberdata name="tablevalidationexpression" display="TableValidationExpression"/>] ;
		+ [<memberdata name="longtablename" display="LongTableName"/>] ;
		+ [<memberdata name="tablevalidationtext" display="TableValidationText"/>] ;
		+ [<memberdata name="inserttriggerexpression" display="InsertTriggerExpression"/>] ;
		+ [<memberdata name="updatetriggerexpression" display="UpdateTriggerExpression"/>] ;
		+ [<memberdata name="deletetriggerexpression" display="DeleteTriggerExpression"/>] ;
		+ [<memberdata name="tablecomment" display="TableComment"/>] ;
		+ [<memberdata name="nextvalueforautoinc" display="NextValueForAutoInc"/>] ;
		+ [<memberdata name="stepforautoinc" display="StepForAutoInc"/>] ;
		+ [<memberdata name="totext" display="toText"/>] ;
		+ [</VFPData>]

	#IF .F.
		LOCAL THIS AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG'
	#ENDIF

	FieldName					= ''
	FieldType					= ''
	FieldWidth					= 0
	FieldDecimals				= 0
	FieldFlags					= 0
	FieldDisplacementInRecord	= 0
	AllowNulls					= .F.
	NoCodePageTranslation		= .F.
	FieldValidationExpression	= ''
	FieldValidationText			= ''
	FieldDefaultValue			= ''
	TableValidationExpression	= ''
	TableValidationText			= ''
	LongTableName				= ''
	InsertTriggerExpression		= ''
	UpdateTriggerExpression		= ''
	DeleteTriggerExpression		= ''
	TableComment				= ''
	NextValueForAutoInc			= 0
	StepForAutoInc				= ''


	PROCEDURE toText
		LPARAMETERS tlHeader

		LOCAL lcText
		lcText	= ''

		IF tlHeader
			lcText	= lcText + PADR('FieldName',10) + '  ' + PADR('Type',4) + '  ' + PADR('Len',3) + '  ' ;
				+ PADR('Dec',3) + '  ' + PADR('Flg',3) + '  ' + PADL('FDiR',4)
			lcText	= lcText + CR_LF + REPLICATE('-',10) + '  ' + REPLICATE('-',4) + '  ' + REPLICATE('-',3) + '  ' ;
				+ REPLICATE('-',3) + '  ' + REPLICATE('-',3) + '  ' + REPLICATE('-',4)
		ELSE
			WITH THIS AS CL_DBF_UTILS_FIELD OF 'FOXBIN2PRG.PRG'
				lcText	= lcText + PADR(.FieldName,10) + '  ' + PADC(.FieldType,4) + '  ' + PADL(.FieldWidth,3) + '  ' ;
					+ PADL(.FieldDecimals,3) + '  ' + PADC(.FieldFlags,3) + '  ' + PADL(.FieldDisplacementInRecord,4)
			ENDWITH
		ENDIF

		RETURN lcText
	ENDPROC


ENDDEFINE


