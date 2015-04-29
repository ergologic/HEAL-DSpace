/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.submission.submit;

import org.dspace.app.xmlui.aspect.submission.AbstractSubmissionStep;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.*;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Constants;
import org.dspace.handle.HandleManager;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Allow the user to select a collection they wish to submit an item to, 
 * this step is sort-of but not officialy part of the item submission 
 * processes. Normaly a user will have selected a collection to submit 
 * too by going to the collection's page, but if that was invalid or the 
 * user came directly from the mydspace page then this step is given.
 *
 * @author Scott Phillips
 * @author Tim Donohue (updated for Configurable Submission)
 */
public class SelectCollectionStep extends AbstractSubmissionStep
{

    /** Language Strings */
    protected static final Message T_head =
            message("xmlui.Submission.submit.SelectCollection.head");
    protected static final Message T_collection =
            message("xmlui.Submission.submit.SelectCollection.collection");
    protected static final Message T_collection_help =
            message("xmlui.Submission.submit.SelectCollection.collection_help");
    protected static final Message T_collection_default =
            message("xmlui.Submission.submit.SelectCollection.collection_default");
    protected static final Message T_submit_next =
            message("xmlui.general.next");

    private static final Message T_no_results = message("xmlui.Submission.Submissions.submit_no_rights");

    public SelectCollectionStep()
    {
        this.requireHandle = true;
    }

    public void addPageMeta(PageMeta pageMeta) throws SAXException,
            WingException
    {

        pageMeta.addMetadata("title").addContent(T_submission_title);
        pageMeta.addTrailLink(contextPath + "/",T_dspace_home);
        pageMeta.addTrail().addContent(T_submission_trail);
    }

    public void addBody(Body body) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
        Collection[] collections; // List of possible collections.
        String actionURL = contextPath + "/submit/" + knot.getId() + ".continue";
        DSpaceObject dso = HandleManager.resolveToObject(context, handle);

        if (dso instanceof Community)
        {
            collections = Collection.findAuthorized(context, ((Community) dso), Constants.ADD);
        }
        else
        {
            collections = Collection.findAuthorized(context, null, Constants.ADD);
        }

        // Basic form with a drop down list of all the collections
        // you can submit too.
        Division div = body.addInteractiveDivision("select-collection",actionURL,Division.METHOD_POST,"primary submission");
        div.setHead(T_submission_head);

        List list = div.addList("select-collection", List.TYPE_FORM);


        if (collections.length>0){

            list.setHead(T_head);

            Select select = list.addItem().addSelect("handle");
            select.setLabel(T_collection);
            select.setHelp(T_collection_help);


            select.addOption("",T_collection_default);
            for (Collection collection : collections)
            {
                Community temp=(Community)collection.getParentObject();
                String current_name=temp.getName()+" > "+ collection.getMetadata("name");

                try {
                    while (temp.getParentObject()!=null)
                    {
                        temp=(Community)temp.getParentObject();
                        current_name=temp.getName()+" > "+ current_name;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
                if (current_name.length() > 120)
                {
                    current_name = current_name.substring(0, 67) + "..."+current_name.substring(current_name.length()-120);
                }

                /*String name = collection.getParentObject().getName() + " > " + collection.getMetadata("name");
               if (name.length() > 80)
               {
                   name = name.substring(0, 77) + "...";
               } */
                select.addOption(collection.getHandle(),current_name);
            }

            Button submit = list.addItem().addButton("submit");
            submit.setValue(T_submit_next);
        } else {
            list.addItem().addContent(T_no_results);
        }
    }

    /**
     * Each submission step must define its own information to be reviewed
     * during the final Review/Verify Step in the submission process.
     * <P>
     * The information to review should be tacked onto the passed in 
     * List object.
     * <P>
     * NOTE: To remain consistent across all Steps, you should first
     * add a sub-List object (with this step's name as the heading),
     * by using a call to reviewList.addList().   This sublist is
     * the list you return from this method!
     *
     * @param reviewList
     *      The List to which all reviewable information should be added
     * @return
     *      The new sub-List object created by this step, which contains
     *      all the reviewable information.  If this step has nothing to
     *      review, then return null!   
     */
    public List addReviewSection(List reviewList) throws SAXException,
            WingException, UIException, SQLException, IOException,
            AuthorizeException
    {
        //Currently, the selecting a Collection is not reviewable in DSpace,
        //since it cannot be changed easily after creating the item
        return null;
    }

    /**
     * Recycle
     */
    public void recycle()
    {
        this.handle = null;
        super.recycle();
    }
}