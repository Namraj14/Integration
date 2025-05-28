// Filename: AccountManagementRestService.cls
//
// Description:
// This Apex REST service fetches Account records filtered by industry
// along with their related Contacts and Cases, returning all results
// inside a structured wrapper class.
//
// Author: Namraj Joshi
// Created: 26-05-2025
// Last Modified: 26-05-2025
// Version: 1.0

@RestResource(urlMapping='/accountMgmt/*')
global with sharing class AccountManagementRestService {

    /**
     * GET /services/apexrest/accountMgmt?industry=Technology
     * 
     * This method retrieves a list of Account records filtered by Industry
     * and includes related Contact and Case records in a wrapper.
     * 
     * @return AccountWrapper - wrapper object containing Account, Contact, and Case lists
     */
    @HttpGet
    global static AccountWrapper getAccounts() {
        // Get query parameters from the REST request
        Map<String, String> paramsMap = RestContext.request.params;
        String accIndustry = paramsMap.get('industry');

        // Fetch Account records based on industry
        List<Account> accList = [
            SELECT Id, Name, Industry, Rating, AnnualRevenue
            FROM Account
            WHERE Industry = :accIndustry
        ];

        // Extract account Ids to use for related Contact and Case queries
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accList) {
            accIds.add(acc.Id);
        }

        // Fetch related Contacts
        List<Contact> conList = [
            SELECT Id, LastName, FirstName, Email, AccountId
            FROM Contact
            WHERE AccountId IN :accIds
        ];

        // Fetch related Cases
        List<Case> caseList = [
            SELECT Id, CaseNumber, Priority, Subject, AccountId
            FROM Case
            WHERE AccountId IN :accIds
        ];

        // Populate and return the wrapper with results
        AccountWrapper accWrapper = new AccountWrapper();
        accWrapper.accList = accList;
        accWrapper.conList = conList;
        accWrapper.caseList = caseList;
        return accWrapper;
    }

    /**
     * Wrapper class used to return combined results
     */
    global class AccountWrapper {
        global List<Account> accList;
        global List<Contact> conList;
        global List<Case> caseList;
    }
}
