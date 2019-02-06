
<?php

    // Configuration.................................
    $destination_folder         = "files/"; // Folder name to store images.
    $file_key                   = 'images'; 
    $max_image_size             = 5120;
    $image_extensions_allowed   = ['jpeg','jpg','png']; 
    $response                   = array();

    // Checking method is Post or not..
    if ($_SERVER['REQUEST_METHOD'] != 'POST'){
        $response['error'] = true;
        $response['message'] = "Method not allowed.";
        echo json_encode($response);
        die();
    }

    if (isset($_FILES[$file_key]) || is_uploaded_file($_FILES[$file_key]['tmp_name'])){
    	
        foreach ($_FILES[$file_key]['name'] as $index => $value) {

            $image_name = $_FILES[$file_key]['name'][$index];
            $image_size = $_FILES[$file_key]['size'][$index] / 1024;
            $image_type = $_FILES[$file_key]['type'][$index]; 
            $image_extension = strtolower(end(explode('.', $image_name)));

            // Checking extension of imagges
            if (!in_array($image_extension, $image_extensions_allowed)){
                $response['error'] = true;
                $response['message'] = "Please upload jpeg or png image.";
                echo json_encode($response);
                die();
            }

            // checking size of images
            if ($image_size > $max_image_size) {
                 $response['error'] = true;
                 $response['message'] = $image_size;
                 echo json_encode($response);
                 die();
            }

            try{
                $destination = $destination_folder.basename($image_name);
                move_uploaded_file($_FILES[$file_key]['tmp_name'][$index], $destination);
            } catch (Exception $e){
                $response['error'] = true;
                $response['message'] = $e->getMessage();
                echo json_encode($response);
            }
        }
        $response['error'] = false;
        $response['message'] = "Image uploaded successfully";
        echo json_encode($response);
     }else{
        $response['error'] = true;
        $response['message'] = "No Images Found";
        echo json_encode($response);
    }
?>

