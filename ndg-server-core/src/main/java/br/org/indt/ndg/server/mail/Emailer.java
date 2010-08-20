/*
*  Copyright (C) 2010  INdT - Instituto Nokia de Tecnologia
*
*  NDG is free software; you can redistribute it and/or
*  modify it under the terms of the GNU Lesser General Public
*  License as published by the Free Software Foundation; either 
*  version 2.1 of the License, or (at your option) any later version.
*
*  NDG is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
*  Lesser General Public License for more details.
*
*  You should have received a copy of the GNU Lesser General Public 
*  License along with NDG.  If not, see <http://www.gnu.org/licenses/ 
*/

package br.org.indt.ndg.server.mail;import java.util.ArrayList;import java.util.Collection;import java.util.Enumeration;import java.util.Properties;import java.util.ResourceBundle;import javax.mail.Message;import javax.mail.Multipart;import javax.mail.Session;import javax.mail.Transport;import javax.mail.internet.InternetAddress;import javax.mail.internet.MimeBodyPart;import javax.mail.internet.MimeMessage;import javax.mail.internet.MimeMultipart;import org.apache.log4j.Logger;public class Emailer extends Thread{	private static org.apache.log4j.Logger log = Logger.getLogger(Emailer.class);	private Collection<Email> collEmail;	public Emailer(){		this.collEmail = new ArrayList<Email>();	}	public Emailer(Email email){		this();		this.addEmail(email);	}	public Collection<Email> getCollEmail() {		return collEmail;	}	public void setCollEmail(Collection<Email> collEmail) {		this.collEmail = collEmail;	}	public void addEmail(Email email){		this.getCollEmail().add(email);	}	@SuppressWarnings("unchecked")	public void sendEmail(){				Properties props = new Properties();		ResourceBundle rb = ResourceBundle.getBundle ("emailconfig");		for (Enumeration keys = rb.getKeys (); keys.hasMoreElements ();){             String key = (String) keys.nextElement ();             String value = rb.getString (key);             props.put (key, value);		}		for(Email email : this.collEmail) {			log.debug(email.toString());			System.getSecurityManager();			try {				SMTPAuthenticator auth = new SMTPAuthenticator( props.getProperty ("mail.smtp.user"),props.getProperty ("mail.smtp.password"));				auth.setEmail(props.getProperty("mail.smtp.user"));				auth.setPassword(props.getProperty("mail.smtp.password"));				Session session = Session.getInstance(props, auth);				if(log.isDebugEnabled())					session.setDebug(true);		        MimeMessage msg = new MimeMessage(session);		        Multipart multipart = new MimeMultipart();		        if(email.getText()!=null && !email.getText().equals("")){					 MimeBodyPart mbpText = new MimeBodyPart();					 mbpText.setText(email.getText());					 multipart.addBodyPart(mbpText);				}		        msg.setFrom(new InternetAddress(props.getProperty("mail.smtp.user")));		        msg.setSubject(email.getSubject());		        for(String recipient : email.getCollRecipient()) {		        	msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));		        }		        msg.setContent(multipart);		        Transport.send(msg);			} catch (Exception e) {				e.printStackTrace();			}		}	}	public void run(){		this.sendEmail();	}		public void send(){		this.start();	}}
