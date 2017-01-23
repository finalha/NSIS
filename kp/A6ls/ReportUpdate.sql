if object_id('TX_OutputVATInvoice') is not null and object_id('AOS_RMS_USER') is not null
	begin
		UPDATE [dbo].[TX_OutputVATInvoice] 
	    SET cCreator=(SELECT left(cRealName,25) FROM AOS_RMS_USER WHERE cGUID=[dbo].[TX_OutputVATInvoice].cCreator)
		WHERE cCreator IN (SELECT cGUID FROM AOS_RMS_USER)

		UPDATE [dbo].[TX_OutputVATInvoice]
		SET cChecker=(SELECT left(cRealName,25) FROM AOS_RMS_USER WHERE cGUID=[dbo].[TX_OutputVATInvoice].cChecker)
		WHERE cChecker IN (SELECT cGUID FROM AOS_RMS_USER)

		UPDATE [dbo].[TX_OutputVATInvoice]
		SET cPayee=(SELECT left(cRealName,25) FROM AOS_RMS_USER WHERE cGUID=[dbo].[TX_OutputVATInvoice].cPayee)
		WHERE cPayee IN (SELECT cGUID FROM AOS_RMS_USER)
	end
;
 