<?php

require_once(dirname(__FILE__).'/TCPDF/tcpdf.php');
ob_start();

$trs = $_GET['transcripts'];
$img = $_GET['img'];
$title = $_GET['title'];
$desc = $_GET['description'];
$storyId = $_GET['storyId'];
$itemId = $_GET['itemId'];
$languages = $_GET['lang'];
$places = $_GET['places'];
$persons = $_GET['persons'];

// create new PDF document
$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

// set document information
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor('Nicola Asuni');
$pdf->SetTitle('TCPDF Example 024');
$pdf->SetSubject('TCPDF Tutorial');
$pdf->SetKeywords('TCPDF, PDF, example, test, guide');

// set default header data
$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, $title, "Story #".$storyId." / Item #".$itemId."\nwww.europeana.transcribathon.eu");

// set header and footer fonts
$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

// set default monospaced font
$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

// set margins
$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

// set auto page breaks
$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

// set image scale factor
$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);


// ---------------------------------------------------------

// set font
$pdf->SetFont('times', '', 18);

// add a page
$pdf->AddPage();

// change font size
$pdf->SetFontSize(30);


// write something only for screen
$pdf->Write(0, $title, '', 0, 'C', true, 0, false, false, 0);

$pdf->SetFontSize(15);

$html='<br/><br/>Description: '.$desc.
'<br>Language(s):<ul>';
foreach($languages as $lang) {
    $html .=  '<li>'.$lang.'</li>';
}
$html .= '</ul>
Places:<ul>';
foreach($places as $place) {
    $html .=  '<li>'.$place.'</li>';
}
$html .= '</ul> 
Personnes:<ol>';
foreach($persons as $person) {
    $arrPers = json_decode($person, true);

    $html .= "<li>Id #".$arrPers["PersonId"]; 
    $html .= '<ul><li>First name: '.$arrPers["FirstName"].'</li>';
    $html .= '<li>Last name: '.$arrPers["LastName"].'</li>';
    $html .= "</ul></li>"; 
}
$html .= "</ol>";
// foreach($properties as $property) {
//     $html .= $property.'<br>';
// }
// $pdf->Write(0, "Description: ".$desc, '', 0, 'L', true, 0, false, true, 0);
// $pdf->Write(0, "Language(s): ", '', 0, 'L', true, 0, false, true, 0);
$pdf->writeHTML($html, true, false, true, false, '');




// ---------------------------------------------------------

// LAYERS

$pdf->AddPage();


// start a new layer
$pdf->startLayer('Text', true, true, false);

// change font size
$pdf->SetFontSize(12);

// write something
// $pdf->Write(0, $trs, '', 0, 'J', true, 0, false, false, 0);
$pdf->writeHTML(rawurldecode($trs), true, false, true, false, '');

// close the current layer
$pdf->endLayer();


// start a new layer
$pdf->startLayer('Image', true, true, false);
list($width, $height) = getimagesize("inputs/img/21744.jpg");
$pdf->Image('inputs/img/21744.jpg', 0, PDF_MARGIN_TOP, 210);

// close the current layer
$pdf->endLayer();

// ---------------------------------------------------------
ob_end_clean();     

//Close and output PDF document
$file = $pdf->Output('i'.$itemId.'.pdf', 'S');
// $binary = base64_decode($file);// $pdf->Output('i'.$itemId.'.pdf', 'I');
// file_put_contents('my.pdf', $binary);
// header('Content-type: application/pdf');
// header('Content-Disposition: attachment; filename="my.pdf"');
echo $file;

//============================================================+
// END OF FILE
//============================================================+
