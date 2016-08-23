<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Game_Status</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Game Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Game Time Completed</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Status__c, &apos;Active&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Game_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Game__c.End_Date_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
