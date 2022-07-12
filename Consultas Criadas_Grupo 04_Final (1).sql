---Consulta de Dados:
SELECT 
       P.[InsuranceID]     AS 'ID.Seguro'
	  ,C.[Appointment]     AS 'ID.Agendamento'
	  ,P.[SSN]             AS 'Cod.Paciente'
	  ,P.[Name]            AS 'Nome Paciente'
	  ,S.[Room]            AS Sala
	  ,L.[BlockFloor]      AS Andar
      ,l.[BlockCode]       AS 'Cod.Andar'
	  ,A.[PrepNurse]       AS 'Cod.Enfermeira'
	  ,N.[Name]            AS 'Nome da Enfermeira'
	  ,N.[Position]        AS 'Cargo da Enfermeiro'
	  ,C.[Dose]            AS Dose
	  ,A.[ExaminationRoom] AS 'Sala de Exame'
	  ,R.[Medication]      AS 'Cod.Medicação'
	  ,G.[Name]            AS Remédio
      ,G.[Brand]           AS 'Marca do Remédio'
	  ,U.[Procedures]      AS 'Cod.procedimento'
	  ,E.[Name]            AS 'Nome do Procedimento'
      ,E.[Cost]            AS 'Valor do Procedimento'
	  ,P.[PCP]             
	  ,A.Physician         AS 'Cod.Médico'
	  ,M.[Name]            AS 'Nome do Médico'
      ,M.[Position]        AS 'Cargo do Médico'  
      ,P.[Address]         AS 'Endereço do Paciente'
      ,P.[Phone]           AS Região
      ,A.[Starto]          AS 'Inicio Agendamento'
      ,A.[Endo]            As'Fim Agendamento'
	  ,S.StayStart         AS 'Incio tratamento'
	  ,S.StayEnd           AS 'Fim do Tratamento'
      ,L.[OnCallStart]     AS 'Começo da Chamada'
      ,l.[OnCallEnd]       
	  AS 'Fim da Chamada'




  FROM [ProjetoFinal_Grupo04].[dbo].[Patient] AS P
  JOIN[ProjetoFinal_Grupo04].[dbo].[Appointment] AS A ON P.SSN=A.Patient
  Join[ProjetoFinal_Grupo04].[dbo].[Prescribes] AS C ON A.Patient=C.Patient
  JOIN[ProjetoFinal_Grupo04].[dbo].[Stay] AS S on P.SSN=s.Patient
  JOIN[ProjetoFinal_Grupo04].[dbo].[Prescribes] AS R on p.SSN=R.Patient
  JOIN[ProjetoFinal_Grupo04].[dbo].[Undergoes] AS U ON P.SSN=U.Patient
  join[ProjetoFinal_Grupo04].[dbo].[Nurse] as N on A.PrepNurse=N.EmployeeID
  Join[ProjetoFinal_Grupo04].[dbo].[Physician] AS M on A.Physician=M.EmployeeID
  Join[ProjetoFinal_Grupo04].[dbo].[Medication] AS G on R.Medication=g.Code
  Join[ProjetoFinal_Grupo04].[dbo].[Procedures] AS E ON U.Procedures=E.Code
  Join[ProjetoFinal_Grupo04].[dbo].[On_Call] AS L ON N.EmployeeID=L.Nurse

--Vila Mariana:
Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Address = 'Vila Mariana'
Where SSN in('1000000211','1000000110','100000078','100000077','100000066','1000000239')

--Capão Redondo:
Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Address = 'Capão Redondo'
Where SSN in('1000000826','1000000624','1000000716','1000000514','1000000413')

--BelA Vista:
Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Address = 'Bela Vista'
Where SSN in ('1000000936','1000000340','1000000441','1000000128','100000055')
--Cotia:
Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Address = 'Cotia'
Where SSN = 100000001

Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Address = 'Campinas'
Where SSN = 100000004

Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Phone = 'Interior'
Where Address IN ('Cotia', 'Campinas')

Update [ProjetoFinal_Grupo04].[dbo].[Patient]
set Phone = 'Capital'
Where Address IN ('Vila Mariana', 'Capão Redondo','Bela Vista') 

SET DATEFORMAT ymd;
Update [ProjetoFinal_Grupo04].[dbo].[Appointment]
set Starto = '2008-04-24 10:00:00.000'
Where  Starto = '2022-10-04 00:00:00.000'


