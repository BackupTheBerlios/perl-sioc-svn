<?php
/**
 * SIOC Exporter API 
 *
 * Allow people to easilly create their own SIOC Exporter for any PHP application
 *
 * @package sioc_inc
 * @author Alexandre Passant <alex@passant.org>
 * @author Uldis Bojars <captsolo@gmail.com> (adaptation to PHP4)
 * @author Thomas Schandl <tom.schandl@gmail.com> (addition of SIOCThread)
 */

define('FORUM_NODE', 'forum');		// TODO: Not used at the moment, remove it?
define('AUTHORS_NODE', 'authors');

define('EXPORTER_URL', 'http://wiki.sioc-project.org/index.php/PHPExportAPI');
define('EXPORTER_VERSION', '1.01');


/**
 * Main exporter class
 *
 * Generates RDF/XML content of SIOC export.
 * - Sets up parameters for generating RDF/XML  
 * - Sets up parameters for SIOC URL generation
 */
class SIOCExporter {

    var $_title;
    var $_blog_url;
    var $_sioc_url;
    var $_encoding;
    var $_generator;

    var $_urlseparator;
    var $_urlequal;
    var $_url4type;
    var $_url4id;
    var $_url4page;
    var $_url_usetype;
    var $_url_suffix;
    var $_type_table;
    var $_suff_table;
	var $_export_email;

    var $object;

    function SIOCExporter() {
        $this->_urlseparator = '&';
        $this->_urlequal = '=';
        $this->_url4type = 'type';
        $this->_url4id = 'id';
        $this->_url4page = 'page';
        $this->_url_usetype = true;
        $this->_url_suffix = '';
        $this->_type_table = array();
        $this->_ignore_suffix = array();
		$this->_export_email = false;
    }

    function setURLParameters($type='type', $id='id', $page='page', $url_usetype = true, $urlseparator='&', $urlequal='=', $suffix='') {
        $this->_urlseparator = $urlseparator;
        $this->_urlequal = $urlequal;
        $this->_url4type = $type;
        $this->_url4id = $id;
        $this->_url4page = $page;
        $this->_url_usetype = $url_usetype;
        $this->_url_suffix = $suffix;
    }

    function setParameters($title, $url, $sioc_url, $encoding, $generator, $export_email=false) {
        $this->_title = $title;
        $this->_blog_url = $url;
        $this->_sioc_url = $sioc_url;
        $this->_encoding = $encoding;
        $this->_generator = $generator;
		$this->_export_email = $export_email;
    }

    function addObject( &$obj ) {
    // Assigns only a single object for now
        $this->object = &$obj;
    }

    function setURLTypeParm($type, $name) {
        $this->_type_table[$type] = $name;
    } 

    function setSuffixIgnore($type) {
        $this->_ignore_suffix[$type] = 1;
    }
	
    function siocURL($type, $id, $page="") {
        if ( isset($this->_type_table[$type]) ) 
            $myID = $this->_type_table[$type]; 
        else 
            $myID = (($this->_url_usetype) ? $type . '_' : '') . $this->_url4id;

        $mySuff = !isset($this->_ignore_suffix[$type]) ? $mySuff = $this->_url_suffix : '';

        $url = $this->_sioc_url . 
            $this->_url4type .$this->_urlequal .  $type . 
            $this->_urlseparator . $myID . $this->_urlequal . $id .
            (($page) ? $this->_urlseparator . $this->_url4page . $this->_urlequal . $page : '');

        $url .= ( ($mySuff) ? $this->_urlseparator . $mySuff : '' );
        return clean($url);
    }

    function export( $rdf_content='' ) {
        header('Content-Type: application/rdf+xml; charset='.$this->_encoding);
        echo '<?xml version="1.0" encoding="'.$this->_encoding.'" ?>'."\n";
?>

<rdf:RDF
    xmlns="http://xmlns.com/foaf/0.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:admin="http://webns.net/mvcb/"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:sioc="http://rdfs.org/sioc/ns#">

<foaf:Document rdf:about="">
	<dc:title>SIOC profile for "<?php echo clean($this->_title); ?>"</dc:title>
	<dc:description>A SIOC profile describes the structure and contents of a community site (e.g., weblog) in a machine processable form. For more information refer to the <?php echo clean('<a href="http://rdfs.org/sioc">SIOC project page</a>'); ?></dc:description>
	<foaf:primaryTopic rdf:resource="<?php echo clean($this->object->_url); ?>"/>
	<admin:generatorAgent rdf:resource="<?php echo clean(EXPORTER_URL); ?>?version=<?php echo EXPORTER_VERSION; ?>"/>
	<admin:generatorAgent rdf:resource="<?php echo clean($this->_generator); ?>"/>
</foaf:Document>

<?php 
        if ($rdf_content) echo $rdf_content; 
        if ($this->object) echo $this->object->getContent( $this );
?>

</rdf:RDF>

<?php 
    }
}

/**
 * Generic SIOC Object
 *
 * All SIOC objects are derived from this.
 */
class SIOCObject {
    var $_note = '';

    function addNote($note) {
        $this->_note = $note;
    }

    function getContent( &$exp ) {
        $rdf =  "<sioc:Object>\n";
        $rdf .= "\t<rdfs:comment>Generic SIOC Object</rdfs:comment>\n";
        $rdf .= "</sioc:Object>\n";
        return $rdf;
    }
}

/**
 * SIOC::Site object
 *
 * Contains information about main SIOC page including:
 *  - site description
 *  - list of forums
 *  - list of users
 */
class SIOCSite extends SIOCObject {

    var $type = 'site';

    var $_url;
    var $_name;
    var $_description;
    var $_forums;
    var $_users;

    function SIOCSite($url, $name, $description) {
        $this->_url = $url;
        $this->_name = $name;
        $this->_description = $description;
        $this->_forums = array();
        $this->_users = array();
    }
    
    function addForum($id, $url) {
        $this->_forums[$id] = $url;
    }

    function addUser($id, $url) {
        $this->_users[$id] = $url;
    } 
    
    function getContent( &$exp ) {
        $rdf = "<sioc:Site rdf:about=\"" . clean($this->_url) ."\">\n";
        $rdf .="\t<dc:title>" . clean($this->_name) . "</dc:title>\n";
        $rdf .= "\t<dc:description>" . clean($this->_description) . "</dc:description>\n";
        $rdf .= "\t<sioc:link rdf:resource=\"" . clean($this->_url) ."\"/>\n";
        if($this->_forums) {
            foreach ($this->_forums as $id => $url) { 
                $rdf .= "\t<sioc:host_of rdf:resource=\"" . clean($url) . "\"/>\n";
            }
        }            
        $rdf .= "\t<sioc:has_Usergroup rdf:nodeID=\"" . AUTHORS_NODE . "\"/>\n";
        $rdf .= "</sioc:Site>\n";
        // Forums
        if($this->_forums) {
            $rdf .= "\n";
            foreach ($this->_forums as $id => $url) { 
                $rdf .= '<sioc:Forum rdf:about="' . clean($url) ."\">\n";
                $rdf .= "\t<sioc:link rdf:resource=\"" . clean($url) . "\"/>\n";
                $rdf .= "\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('forum', $id) ."\"/>\n";
                $rdf .= "</sioc:Forum>\n";
            }
        }
        // Usergroup
        if($this->_users) {
            $rdf .= "\n";
            $rdf .= '<sioc:Usergroup rdf:nodeID="' . AUTHORS_NODE . "\">\n";
            $rdf .= "\t<sioc:name>Authors for \"" . clean($this->_name) . "\"</sioc:name>\n";
                foreach ($this->_users as $id => $url) {
                    $rdf .= "\t<sioc:has_member>\n";
                    $rdf .= "\t\t<sioc:User rdf:about=\"" . clean($url) ."\">\n";
                    $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('user', $id). "\"/>\n";
                    $rdf .= "\t\t</sioc:User>\n";
                    $rdf .= "\t</sioc:has_member>\n";
                }
            $rdf .= "</sioc:Usergroup>\n";
        }
		
        return $rdf;
    }
}

// Export detaille d'un utilisateur
/** 
 * SIOC::User object
 *
 * Contains user profile information
 */
class SIOCUser extends SIOCObject {

    var $type = 'user';

    var $_id;
	var $_nick;
    var $_uri;
    var $_name;
    var $_email;
    var $_sha1;
    var $_homepage;
    var $_foaf_uri;
    var $_role;

    function SIOCUser($id, $uri, $name, $email, $homepage='', $foaf_uri='', $role=false, $nick='') {
        $this->_id = $id;
        $this->_uri = $uri;
        $this->_name = $name;
        
		if (preg_match_all('/^.+@.+\..+$/Ui', $email, $check, PREG_SET_ORDER)) {
			if (preg_match_all('/^mailto:(.+@.+\..+$)/Ui', $email, $matches, PREG_SET_ORDER)) {
				$this->_email = $email; 
				$this->_sha1 = sha1($email);
			} else {
				$this->_email = "mailto:".$email; 
				$this->_sha1 = sha1("mailto:".$email);
				}
		}
        $this->_homepage = $homepage;
        $this->_foaf_uri = $foaf_uri;
        $this->_url = $foaf_uri;
        $this->_role = $role;
		$this->_nick = $nick;
    }

    function getContent( &$exp ) {
        $rdf = "<foaf:Person rdf:about=\"" . clean($this->_foaf_uri) . "\">\n";
        if($this->_name) $rdf .= "\t<foaf:name>". $this->_name . "</foaf:name>\n";
        if($this->_email) { $rdf .= "\t<foaf:mbox_sha1sum>" . $this->_sha1 . "</foaf:mbox_sha1sum>\n"; }
        $rdf .= "\t<foaf:holdsAccount>\n";
        $rdf .= "\t\t<sioc:User rdf:about=\"" . clean($this->_uri) ."\">\n";
        if($this->_nick) $rdf .= "\t\t\t<sioc:name>" . $this->_nick . "</sioc:name>\n";
        if($this->_email) {
            if ($exp->_export_email) { $rdf .= "\t\t\t<sioc:email rdf:resource=\"" . $this->_email ."\"/>\n"; }
            $rdf .= "\t\t\t<sioc:email_sha1>" . $this->_sha1 . "</sioc:email_sha1>\n";
        }
        if($this->_role) {
            $rdf .= "\t\t\t<sioc:has_function>\n";
            $rdf .= "\t\t\t\t<sioc:Role>\n";
            $rdf .= "\t\t\t\t\t<sioc:name>" . $this->_role . "</sioc:name>\n";
            $rdf .= "\t\t\t\t</sioc:Role>\n";
            $rdf .= "\t\t\t</sioc:has_function>\n";
        }
        $rdf .= "\t\t</sioc:User>\n";    
        $rdf .= "\t</foaf:holdsAccount>\n";    
        $rdf .= "</foaf:Person>\n";  
        return $rdf;
    }
}

// Export detaille d'un utilisateur
/** 
 * SIOC::Thread object
 *
 * Contains information about a SIOC Thread in a SIOC Forum
  - list of posts in that thread
 */

class SIOCThread extends SIOCObject {

    var $type = 'thread';
    var $_id;
    var $_url;
	var $_page;
    var $_posts;
	var $_next;
	var $_views;
	var $_topics;

    function SIOCThread($id, $url, $page, $views='', $topics='') {
        $this->_id = $id;
        $this->_url = $url;
		$this->_page = $page;
        $this->_posts = array();
		$this->_next = false;
		$this->_views = $views;
		$this->_topics = $topics;
    }

    function addPost($id, $url, $prev='', $next='') {
		$this->_posts[$id] = array("url" => $url, "prev" => $prev, "next" => $next);
    }
	
	function setNextPage($next) {
        $this->_next = $next;
    }

    function getContent( &$exp) {
        $rdf .= '<sioc:Thread rdf:about="' . clean($this->_url) . "\">\n";
        $rdf .= "\t<sioc:link rdf:resource=\"" . clean($this->_url) . "\"/>\n";
        if ($this->_views)  $rdf .= "\t<sioc:num_views>" . $this->_views . "</sioc:num_views>\n";
		if ($this->_note)   $rdf .= "\t<rdfs:comment>" . $this->_note . "</rdfs:comment>\n";
		if ($this->_topics) { 
				foreach ($this->_topics as $id => $topic) {
					$rdf .= "\t<sioc:topic>" . $topic . "</sioc:topic>\n"; // todo - each topic needs to have a URI
				}
			}
		/*if($this->_topics) {
            foreach($this->_topics as $url=>$topic) {
                $rdf .= "\t<sioc:topic rdfs:label=\"$topic\" rdf:resource=\"" . clean($url) ."\"/>\n";
            }
        }
		*/
        if ($this->_posts) {
            foreach($this->_posts as $id => $data) {
                $rdf .= "\t<sioc:container_of>\n";
                $rdf .= "\t\t<sioc:Post rdf:about=\"" .clean($data[url]) ."\">\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('post', $id) . "\"/>\n";
				if ($data[prev]) { $rdf .= "\t\t\t<sioc:previous_by_date rdf:resource=\"" . clean($data[prev]) . "\"/>\n"; }
				if ($data[next]) { $rdf .= "\t\t\t<sioc:next_by_date rdf:resource=\"" . clean($data[next]) . "\"/>\n"; }
                $rdf .= "\t\t</sioc:Post>\n";
                $rdf .= "\t</sioc:container_of>\n";
            }
        }
		if($this->_next) {
            $rdf .= "\r<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('thread', $this->_id, $this->_page+1) ."\"/>\n";
        }
        $rdf .= "</sioc:Thread>\n";
        return $rdf;
    }
}

// Export d'un forum avec une liste de posts -variable (next with seeAlso)
/**
 * SIOC::Forum object
 *
 * Contains information about SIOC Forum (blog, ...):
 *  - description of a forum
 *  - list of posts within a forum [partial, paged]
 */

class SIOCForum extends SIOCObject {

    var $type = 'forum';

    var $_id;
    var $_url;    
    var $_page;
    var $_posts;
    var $_next;
// XXX - need to separate exporter and SIOC object hierarchy - or we get name clashed between exporter and item - TODO ask uldis about that
    var $_blog_title;
    var $_description;
	
	var $_threads;
	
    function SIOCForum($id, $url, $page, $title='', $descr='') {
        $this->_id = $id;
        $this->_url = $url;
        $this->_page = $page;
        $this->_posts = array();
        $this->_next = false;
        $this->_blog_title = $title;
        $this->_description = $descr;
		$this->_threads = array();
    }
	
    function addPost($id, $url) {
        $this->_posts[$id] = $url;
    }
	
	function addThread($id, $url) {
        $this->_threads[$id] = $url;
    }

    function setNextPage($next) {
        $this->_next = $next;
    }

    function getContent( &$exp) {
        $rdf .= '<sioc:Forum rdf:about="' . clean($this->_url) . "\">\n";
        $rdf .= "\t<sioc:link rdf:resource=\"" . clean($this->_url) . "\"/>\n";
        if ($this->_blog_title)  $rdf .= "\t<dc:title>" . $this->_blog_title . "</dc:title>\n";
        if ($this->_description) $rdf .= "\t<dc:description>" . $this->_description . "</dc:description>\n";
        if ($this->_note)        $rdf .= "\t<rdfs:comment>" . $this->_note . "</rdfs:comment>\n";
		
		if ($this->_threads) {
			foreach($this->_threads as $id => $uri) {
				$rdf .= "\t<sioc:parent_of>\n";
				$rdf .= "\t\t<sioc:Thread rdf:about=\"" .clean($uri) ."\">\n";
				$rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('thread', $id) . "\"/>\n";
				$rdf .= "\t\t</sioc:Thread>\n";
				$rdf .= "\t</sioc:parent_of>\n";
            }
		}
		
        if($this->_posts) {
            foreach($this->_posts as $id => $url) {
                $rdf .= "\t<sioc:container_of>\n";
                $rdf .= "\t\t<sioc:Post rdf:about=\"" .clean($url) ."\">\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('post', $id) . "\"/>\n";
                $rdf .= "\t\t</sioc:Post>\n";
                $rdf .= "\t</sioc:container_of>\n";
            }
        }
		
        if($this->_next) {
            $rdf .= "\r<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('forum', $this->_id, $this->_page+1) ."\"/>\n";
        }
        $rdf .= "</sioc:Forum>\n";
		
        return $rdf;
    }
}

/**
 * SIOC::Post object
 *
 * Contains information about a post
 */
class SIOCPost extends SIOCObject {

    var $type = 'post';

    var $_url;
    var $_subject;
    var $_content;
    var $_encoded;
    var $_creator;
    var $_created;
    var $_updated;
    var $_topics;
    var $_links;
    var $_comments;
    var $_reply_of;

    function SIOCPost($url, $subject, $content, $encoded, $creator, $created, $updated="", $topics=array(), $links=array()) {
        $this->_url = $url;
        $this->_subject = $subject;
        $this->_content = $content;
        $this->_encoded = $encoded;
        $this->_creator = $creator;
        $this->_created = $created;
        $this->_updated = $updated;
        $this->_topics = $topics;
        $this->_links = $links;
        $this->_comments = array();
        $this->_reply_of = array();
		// echo $this->_content;
    }

    function addComment($id, $url) {
        $this->_comments[$id] = $url;
    }

    function addReplyOf($id, $url) {
        $this->_reply_of[$id] = $url;    
    }

    function getContent( &$exp ) {
        $rdf = "<sioc:Post rdf:about=\"" . clean($this->_url) . "\">\n";
        //$rdf .= "\t<sioc:type>$type</sioc:type>\n";
        if ($this->_subject) { $rdf .= "\t<dc:title>" . $this->_subject . "</dc:title>\n"; }

      if ($this->_creator)
        if ($this->_creator->_id) {
                $rdf .= "\t<sioc:has_creator>\n";
                $rdf .= "\t\t<sioc:User rdf:about=\"" . clean($this->_creator->_uri) ."\">\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('user', $this->_creator->_id). "\"/>\n";
                $rdf .= "\t\t</sioc:User>\n";
                $rdf .= "\t</sioc:has_creator>\n";
                $rdf .= "\t<foaf:maker>\n";
                $rdf .= "\t\t<foaf:Person rdf:about=\"" . clean($this->_creator->_foaf_uri) ."\">\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('user', $this->_creator->_id). "\"/>\n";
                $rdf .= "\t\t</foaf:Person>\n";
                $rdf .= "\t</foaf:maker>\n";
        } else {
                $rdf .= "\t<foaf:maker>\n";
                $rdf .= "\t\t<foaf:Person";
                if($this->_creator->_name) $rdf .= " foaf:name=\"" . $this->_creator->_name ."\"";
                if($this->_creator->_sha1) $rdf .= " foaf:mbox_sha1sum=\"" . $this->_creator->_sha1 ."\"";
                if($this->_creator->_name) $rdf .= ">\n\t\t\t<foaf:homepage rdf:resource=\"" . $this->_creator->_homepage ."\"/>\n\t\t</foaf:Person>\n";
                else $rdf .= "/>\n";
                $rdf .= "\t</foaf:maker>\n";
        }

        $rdf .= "\t<dcterms:created>" . $this->_created . "</dcterms:created>\n";
        if ($this->_updated AND ($this->_created != $this->_updated) ) $rdf .= "\t<dcterms:modified>" . $this->_updated . "</dcterms:modified>\n";
        $rdf .= "\t<sioc:content>" . pureContent($this->_content) . "</sioc:content>\n";
			
        $rdf .= "\t<content:encoded><![CDATA[" . $this->_encoded . "]]></content:encoded>\n";
        if($this->_topics) {
            foreach($this->_topics as $url=>$topic) {
                $rdf .= "\t<sioc:topic rdfs:label=\"$topic\" rdf:resource=\"" . clean($url) ."\"/>\n";
            }
        }
        if($this->_links) {
            foreach($this->_links as $url=>$link) {
                $rdf .= "\t<sioc:links_to rdfs:label=\"$link\" rdf:resource=\"" . clean($url) ."\"/>\n";
            }
        }
        if($this->_reply_of) {
            foreach($this->_reply_of as $id => $url) {
                $rdf .= "\t<sioc:reply_of>\n";
                $rdf .= "\t\t<sioc:Post rdf:about=\"" . clean($url) . "\">\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('post', $id) . "\"/>\n";
                $rdf .= "\t\t</sioc:Post>\n";
                $rdf .= "\t</sioc:reply_of>\n";
            }
        }
        if($this->_comments) {
            foreach($this->_comments as $id => $url) {
                $rdf .= "\t<sioc:has_reply>\n";
                $rdf .= "\t\t<sioc:Post rdf:about=\"" . clean($url) ."\">\n";
        //        if($comments->f('comment_trackback')) $rdf .= "\t\t\t<sioc:type>" . POST_TRACKBACK . "</sioc:type>\n"; 
        //        else $rdf .= "\t\t\t<sioc:type>" . POST_COMMENT  . "</sioc:type>\n";
                $rdf .= "\t\t\t<rdfs:seeAlso rdf:resource=\"" . $exp->siocURL('comment', $id) . "\"/>\n";
                $rdf .= "\t\t</sioc:Post>\n";
                $rdf .= "\t</sioc:has_reply>\n";
            }
        }
        $rdf .= "</sioc:Post>";
        return $rdf;    
    }
}

/**
 * "Clean" text
 *
 * Transforms text so that it can be safely put into XML markup
 */
if (!function_exists('clean')) {
  function clean( $text ) {
#    return htmlentities( $text );
    return htmlentities2( $text );
  }
}

/**
 * HTML Entities 2
 *
 * Same a HTMLEntities, but avoids double-encoding of entities
 */
if (!function_exists('htmlentities2')) {
  function htmlentities2($myHTML) {
    $translation_table=get_html_translation_table (HTML_ENTITIES,ENT_QUOTES);
    $translation_table[chr(38)] = '&';
    return preg_replace("/&(?![A-Za-z]{0,4}\w{2,3};|#[0-9]{2,3};)/","&amp;" , strtr($myHTML, $translation_table));
    //return htmlentities(strtr(str_replace(' ', '%20', $myHTML), $translation_table));
  }
}

/**
 * pureContent
 *
 * Prepares text-only representation of HTML content
 */
if (!function_exists('pureContent')) {
  function pureContent($content) {
    // Remove HTML tags 
    // May add more cleanup code later, if validation errors are found
    return strip_tags($content);
  }
}
?>
