public class SecurityUtil {
    // Cette class ==> Filtre les enregistrements en supprimant les champs non accessibles selon le type d'accès (READ, CREATE, UPDATE). Utile avant d'exposer des données à l'utilisateur.
    
    public static List<SObject> stripFields(List<SObject> records, AccessType accessType) {
        if(records == null || records.isEmpty()) return records;
        return (List<SObject>) Security.stripInaccessible(accessType, records).getRecords();
    }


    // Voici des méthodes utilitaires (helpers) qui : Vérifient si l’utilisateur a le droit d’exécuter une action (CRUD) sur : Un objet entier ➔ Create, Update, Delete ou un champ spécifique ➔ Read, Write ......................


    // Vérifie si l'utilisateur a le droit de créer des enregistrements pour ce type d'objet
    public static void checkCreateAccess(Schema.SObjectType sObjectType) {
        if (!sObjectType.isCreateable()) {
            throw new SecurityException('You do not have create access to ' + sObjectType.getDescribe().getName());
        }
    }

    // Vérifie si l'utilisateur a le droit de mettre à jour des enregistrements pour ce type d'objet
    public static void checkUpdateAccess(Schema.SObjectType sObjectType) {
        if (!sObjectType.isUpdateable()) {
            throw new SecurityException('You do not have update access to ' + sObjectType.getDescribe().getName());
        }
    }

    // Vérifie si l'utilisateur a le droit de supprimer des enregistrements pour ce type d'objet
    public static void checkDeleteAccess(Schema.SObjectType sObjectType) {
        if (!sObjectType.isDeletable()) {
            throw new SecurityException('You do not have delete access to ' + sObjectType.getDescribe().getName());
        }
    }

    // Vérifie si l'utilisateur a accès en lecture à un champ spécifique
    public static void checkReadAccess(Schema.SObjectField field) {
        if (!field.getDescribe().isAccessible()) {
            throw new SecurityException('Read access denied for field ' + field.getDescribe().getName());
        }
    }

    // Vérifie si l'utilisateur a accès en écriture à un champ spécifique
    public static void checkWriteAccess(Schema.SObjectField field) {
        if (!field.getDescribe().isUpdateable()) {
            throw new SecurityException('Write access denied for field ' + field.getDescribe().getName());
        }
    }
}